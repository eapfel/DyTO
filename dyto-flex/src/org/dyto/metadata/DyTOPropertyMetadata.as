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

package org.dyto.metadata
{
	import flash.utils.getDefinitionByName;
	
	import mx.collections.IList;
	
	import org.dyto.exception.DyTOMappingError;
	
	/**
	 * @author Ezequiel
	 * @date Mar 12, 2010
	 * @since 0.1	
	 */
	public class DyTOPropertyMetadata
	{
		static private const LAZY:String = "lazy";
		
		static private const PAGE_SIZE:String = "pageSize";
		
		static private const PATH:String = "path";
		
		static private const DYTO:String = "dyto";
		
		/**
		 * Used to verify if dyto="package::aClass" is correct 
		 */		
		static private const PROPERTY_REGEX:RegExp = /^[(a-z)][\w|\.]*::\w+$/
		
		/**
		 * Determines whether the property is lazy
		 * @default false  
		 */
		public var lazy:Boolean = false;
		
		/**
		 * The page size if it's a DyTOList
		 */
		public var pageSize:int;
		
		/**
		 * Path to the property on the server 
		 */
		public var path:String;
		
		/**
		 * Class type 
		 */		
		public var type:Class;
		
		/**
		 * DyTO's Name   
		 */		
		public var dyto:Class;
		
		/**
		 * Creates a DytoPropertyMetadata 
		 */	
		static public function create(metadataInfo:XMLList, variable:XML):DyTOPropertyMetadata
		{
			var propertyMetadata:DyTOPropertyMetadata;
			
			var classType:Class = Class(getDefinitionByName(variable.@type))
			
			var defaultPath:String = variable.@name; 
				
			var medatadaInfoArgs:XMLList = metadataInfo.arg;	
			
			if (classType == IList)
			{
				propertyMetadata = createForDyTOListProperty(medatadaInfoArgs,classType,defaultPath)
			}
			else
			{
				propertyMetadata = createForDyTOProperty(medatadaInfoArgs,classType,defaultPath)
			}
			
			return propertyMetadata;
		}
		
		/**
		 * 
		 * Creates metadata for DyTOListPropertyDescription 
		 * 
		 */		
		static private function createForDyTOListProperty(medatadaInfoArgs:XMLList, classType:Class, defaultPath:String):DyTOPropertyMetadata
		{
			var propertyMetadata:DyTOPropertyMetadata = new DyTOPropertyMetadata();
			
			if (!(medatadaInfoArgs && medatadaInfoArgs.length() > 0))
				throw new DyTOMappingError("dyto property must be setted for IList "+defaultPath+". e.g: DyTOProperty(dyto=\"package::aDyTOClass\")");
			
			propertyMetadata.pageSize = MetadataUtils.getIntValueOrDefault(PAGE_SIZE, medatadaInfoArgs, 20); 
			propertyMetadata.lazy = MetadataUtils.getBooleanValueOrDefault(LAZY, medatadaInfoArgs, false);
			propertyMetadata.path = MetadataUtils.getStringValueOrDefault(PATH, medatadaInfoArgs, defaultPath);
			propertyMetadata.dyto = getDyTOClass(medatadaInfoArgs, defaultPath);
			propertyMetadata.type = classType;
			
			return propertyMetadata; 
		}
		
		/**
		 * 
		 * Creates metadata for DyTOPropertyDescription 
		 * 
		 */		
		static private function createForDyTOProperty(medatadaInfoArgs:XMLList, classType:Class, defaultPath:String):DyTOPropertyMetadata
		{
			var propertyMetadata:DyTOPropertyMetadata = new DyTOPropertyMetadata();
			
			propertyMetadata.pageSize = 0;
			propertyMetadata.lazy = MetadataUtils.getBooleanValueOrDefault(LAZY, medatadaInfoArgs, false);
			propertyMetadata.path = MetadataUtils.getStringValueOrDefault(PATH, medatadaInfoArgs, defaultPath);
			propertyMetadata.dyto = classType;
			propertyMetadata.type = classType;
			
			return propertyMetadata; 
		}
		
		/**
		 * Return DyTOClass representation, if not exist throws an excepton
		 * 
		 * @param medatadaInfo Class' metadataInfo 
		 * @param defaultPath only be used to throw an exception
		 * @return a Class 
		 */		
		static private function getDyTOClass(medatadaInfo:XMLList, defaultPath:String):Class
		{
			var dytoClassString:String = MetadataUtils.getStringValueOrDefault(DYTO,medatadaInfo,null);
			var dytoClass:Class = null;
			
			if (!dytoClassString)
				throw new DyTOMappingError("dyto property must be setted for IList "+defaultPath+". e.g: DyTOProperty(dyto=\"package::aDyTOClass\")");
			
			if (dytoClassString.search(PROPERTY_REGEX) == -1)
				throw new DyTOMappingError("dyto property "+dytoClassString+" malformed for IList "+defaultPath+". e.g: package::aDyTOClass");
			
			try {
				dytoClass = Class(getDefinitionByName(dytoClassString))
			}
			catch (e:ReferenceError)
			{
				throw new DyTOMappingError("dyto property "+dytoClassString+" does not exist for IList "+defaultPath);	
			}
			
			return dytoClass;
		}
		
		public function toString():String
		{
			return "DyTOProperty(lazy="+lazy+", pageSize="+pageSize+", path="+path+", dyto="+dyto+")";
		}
	}
}