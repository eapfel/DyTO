////////////////////////////////////////////////////////////////////
// Copyright 2010 the original author or authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
////////////////////////////////////////////////////////////////////

package org.dyto.description.factory.impl
{
	import flash.utils.Dictionary;
	
	import mx.collections.IList;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.DescribeTypeCache;
	
	import org.dyto.description.DescriptionDto;
	import org.dyto.description.DyTOListPropertyDescriptionDto;
	import org.dyto.description.DyTOPropertyDescriptionDto;
	import org.dyto.description.PropertyDescriptionDto;
	import org.dyto.description.factory.DescriptionFactory;
	import org.dyto.exception.DyTOError;
	import org.dyto.metadata.DyTOMetadata;
	import org.dyto.metadata.DyTOPropertyMetadata;
	import org.dyto.metadata.MetadataUtils;
	
	
	/**
	 * @author Ezequiel
	 * @date Mar 7, 2010
	 * @since 0.1	
	 */
	public class DescriptionFactoryImpl implements DescriptionFactory
	{
		static private const LOG:ILogger = Log.getLogger("org.dyto.description.factory.impl.DescriptionFactoryImpl");
		
		static private const NOT_MAPPED: DescriptionDto = new DescriptionDto();
		
		/**
		 * DyTOClass metatag 
		 */		
		static private const DYTO_CLASS_METADATA:String = "DyTOClass";
		
		/**
		 * DyTOProperty metatag 
		 */		
		static private const DYTO_PROPERTY_METADATA:String = "DyTOProperty";
		
		/**
		 * 
		 */		
		static private const TRANSIENT_TAG:String = "Transient"
		
		/**
		 * 
		 */		
		static private const READ_ONLY_ACCESSOR:String = "readonly"
		
		/**
		 * 
		 */		
		static private var descriptionCache:Dictionary = new Dictionary();
		
		/**
		 * @inheritDoc  
		 */		
		public function descriptionFor(dytoClass:Class):DescriptionDto
		{
			
			var descriptionDto:DescriptionDto = descriptionCache[dytoClass];
			
			// check for this type in Dictionary and return it if already exists
			if (!descriptionDto)
			{
				LOG.debug("Miss DescriptionDto doesn't exist for class -> "+dytoClass+". Call buildDescriptionFor");
				
				descriptionCache[dytoClass] = null;
				
				descriptionDto = buildDescriptionFor(dytoClass);
				
				descriptionCache[dytoClass] = descriptionDto;
			}
			else
			{
				LOG.debug("Hit for DyTOClass -> "+dytoClass);
			}
			
			if (descriptionDto == NOT_MAPPED)
				return null;
				
			return descriptionDto;
		}
		
		/**
		 * 
		 * @param dytoClass The class to assemble the description
		 * @return a DescriptionDto 
		 * 
		 */		
		protected function buildDescriptionFor(dytoClass:Class):DescriptionDto
		{
			//le gano 0.06s a describeType(dytoClass) con DescribeTypeCache.describeType(dytoClass).typeDescription							
			var description:XML = DescribeTypeCache.describeType(dytoClass).typeDescription;
			
			var descriptionDto:DescriptionDto = new DescriptionDto();
			
			var dytoMetadata:DyTOMetadata;

			//Check if dytoClass
			if (!isDytoClass(description))
			{
				LOG.debug(description.@name+" is not a DyTOClass");
				return NOT_MAPPED;
			}
			
			LOG.debug("Build DyTOClass -> "+ description.@name);
			
			dytoMetadata = DyTOMetadata.create(getMetadata(description..metadata,DYTO_CLASS_METADATA),description.@name);			
			
			LOG.debug("DyTOClass -> "+ dytoMetadata);
			
			descriptionDto.dytoType = dytoClass;
			
			//Set className
			descriptionDto.remoteClassName = dytoMetadata.alias;
			
			//Add to map
			descriptionCache[dytoClass] = descriptionDto;
			
			//Add properties
			addProperties(description,descriptionDto)
			
			//TODO: Soportar polimorfismo en los metodos
			//Un posibilidad puede ser que al momento de armar la descripcion de una subclass buscar el parent dyto y 
			//agregarle las propiedades del hijo sino las tiene
			//var parents:XMLList = description..extendsClass
			
			return descriptionDto;
		}
		
		/**
		 * Verifica si la clase es una DyTO class 
		 * @param description
		 * @return True if is a DyTOClass otherwise false 
		 * 
		 */		
		private function isDytoClass(description:XML):Boolean
		{
			return internalHasMetadata(description..metadata, DYTO_CLASS_METADATA);
		}
		
		
		/**
		 * Adds properties to the descriptionDto
		 * @param descriptionDto
		 * @param description
		 *  
		 */
		private function addProperties(description:XML, descriptionDto:DescriptionDto):void
		{
			var variables:XMLList = description..accessor.(@access != READ_ONLY_ACCESSOR) + description..variable;	
			var variablesLength:int = variables.length();
				
			var variable:XML;	
			var property: PropertyDescriptionDto;
			
			if (variablesLength == 0)
				throw new DyTOError("DyTOClass "+description.@name+" doesn't include any property")
			
			for(var i:int = 0; i< variablesLength; i++)
			{
				variable = variables[i];
				property = parseProperty(variable);
				
				if(property != null)
				{
					descriptionDto.properties[variable.@name] = property;
					
					LOG.debug("Add property -> "+variable.@name+", path -> "+property.path)
				}
				
			}
		}
		
		/**
		 * Builds a PropertyDescriptionDto from the XML definition
		 * @param variable property's XML definition
		 * @return A PropertyDescriptionDto 
		 * 
		 */		
		private function parseProperty(variable:XML):PropertyDescriptionDto
		{
			var propertyDescriptionDto:PropertyDescriptionDto = null; 
			var name:String = variable.@name;
			var metadata:XMLList = variable.metadata;
			
			//Check if the property is not transient
			if(!internalHasMetadata(metadata, TRANSIENT_TAG))
			{
				//Check if the property is a DyTOProperty
				if (internalHasMetadata(metadata, DYTO_PROPERTY_METADATA))
				{
					propertyDescriptionDto = parseMetadata(variable, metadata);
				}
				else
				{
					propertyDescriptionDto = new PropertyDescriptionDto();      
					propertyDescriptionDto.path = name;
				}
			}
			
			return propertyDescriptionDto;
		}
		
		/**
		 * Builds a PropertyDescriptionDto from the XML definition if variable contains DYTO_PROPERTY_METADATA
		 * @variable property's XML definition
		 * @param metadata 
		 * @return PropertyDescriptionDto
		 */		
		private function parseMetadata(variable:XML, metadata:XMLList):PropertyDescriptionDto
		{
			var propertyDescriptionDto:PropertyDescriptionDto = null;
			
			var dytoPropertyMetadata:DyTOPropertyMetadata = DyTOPropertyMetadata.create(getMetadata(metadata,DYTO_PROPERTY_METADATA), variable);
			
			//If type is IList, Creates a DyTOListPropertyDescriptionDto
			//otherwise creates a DyTOPropertyDescriptionDto
			if (dytoPropertyMetadata.type == IList)
				propertyDescriptionDto = createDytoListPropertyDescription(dytoPropertyMetadata);
			else
				propertyDescriptionDto = createDytoPropertyDescription(dytoPropertyMetadata);
			
			return propertyDescriptionDto
		}
		
		/**
		 * Builds a DytoListPropertyDto 
		 * @param dytoPropertyMetadata
		 * @return a new DytoListPropertyDto
		 * 
		 */		
		private function createDytoListPropertyDescription(dytoPropertyMetadata:DyTOPropertyMetadata):PropertyDescriptionDto
		{
			LOG.debug("Create DyTOListProperty for -> "+dytoPropertyMetadata);
			
			var dytoListPropertyDescription:DyTOListPropertyDescriptionDto = new DyTOListPropertyDescriptionDto();
			
			assignCommontDyTOProperties(dytoListPropertyDescription,dytoPropertyMetadata);
			
			dytoListPropertyDescription.pageSize = dytoPropertyMetadata.pageSize;
			
			return dytoListPropertyDescription;
		}
		
		/**
		 * Builds a DyTOPropertyDescriptionDto 
		 * @param dytoPropertyMetadata
		 * @return new DyTOPropertyDescriptionDto
		 * 
		 */		
		private function createDytoPropertyDescription(dytoPropertyMetadata:DyTOPropertyMetadata):PropertyDescriptionDto
		{
			LOG.debug("Create DyTOProperty for -> "+dytoPropertyMetadata);
			
			var dytoPropertyDescription:DyTOPropertyDescriptionDto = new DyTOPropertyDescriptionDto();
			
			assignCommontDyTOProperties(dytoPropertyDescription,dytoPropertyMetadata);
			
			return dytoPropertyDescription;
		}
		
		/**
		 * @private
		 * @param dytoProperty
		 * 
		 */		
		private function assignCommontDyTOProperties(dytoProperty:DyTOPropertyDescriptionDto, dytoPropertyMetadata:DyTOPropertyMetadata):void
		{
			dytoProperty.dytoType = dytoPropertyMetadata.dyto;
			dytoProperty.lazy = dytoPropertyMetadata.lazy;
			dytoProperty.path = dytoPropertyMetadata.path;
			
			var descriptionDto:DescriptionDto = descriptionFor(dytoPropertyMetadata.dyto);
			
			if (dytoProperty)
				dytoProperty.descriptionDto = descriptionDto;
		}
		
		/**
		 *  Checks if a metadataInfo contains metadaName
		 *  @private
		 */
		private function internalHasMetadata(metadataInfo:XMLList, metadataName:String):Boolean
		{
			return getMetadata(metadataInfo,metadataName) != null ? true : false; 
		}
			
		/**
		 * Gets metadaInfo from metadataName
		 * 
		 * @private
		 * @param metadataInfo
		 * @param metadataName
		 * @return 
		 * 
		 */		
		private function getMetadata(metadataInfo:XMLList, metadataName:String):XMLList
		{
			return MetadataUtils.getMetadata(metadataInfo,metadataName);
		}
		
	}
}