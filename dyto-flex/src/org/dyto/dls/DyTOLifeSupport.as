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

package org.dyto.dls
{
	import flash.utils.Dictionary;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.dyto.DyTOs;
	import org.dyto.description.DescriptionDto;
	import org.dyto.description.DyTOListPropertyDescriptionDto;
	import org.dyto.description.PropertyDescriptionDto;
	import org.dyto.list.DyTOList;
	import org.dyto.listener.PropertyListener;
	import org.dyto.reference.QueryDto;
	import org.dyto.reference.ReferenceDto;
	
	/**
	 * @author Ezequiel
	 * @date Mar 14, 2010
	 * @since 0.1	
	 */
	public class DyTOLifeSupport extends DyTOLifeSupportBase
	{
		/**
		 * @private
		 * Log 
		 */		
		static private const LOG:ILogger = Log.getLogger("org.dyto.dls");
		
		/**
		 * Dictionary of PropertyListener 
		 */		
		private var propertyListeners:Dictionary;
		
		private var ignoreUpdates:Boolean;
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		public function DyTOLifeSupport(_description:DescriptionDto, _query:QueryDto, _dyto:Object)
		{
			super(_description,_query)
			
			ignoreUpdates = true;
			
			dyto = _dyto;
			
			DyTOs.registerDLS(dyto,this);
			
			bindProperties();
			
			ignoreUpdates = false;
		}
		
		//--------------------------------------------------------------
		//
		// Static Public Methods
		//
		//--------------------------------------------------------------
		/**
		 * Creates a transint DyTO to be saved in the db
		 * @param description
		 * @param reference
		 * @return a new DLS
		 */		
		static public function createTransientDyTO(description:DescriptionDto, reference:ReferenceDto):Object
		{
			LOG.debug("Creates a transient dyto for -> "+description.dytoType);
			
			var dls:DyTOLifeSupport = createDLS(description, reference);
			dls.instantiateChildren();
			
			return dls.dyto;
		}
		
		
		//--------------------------------------------------------------
		//
		// Static Private Methods
		//
		//--------------------------------------------------------------
		/**
		 * Create s a new DLS
		 * @param description
		 * @param reference
		 * @return a new DLS
		 */		
		static private function createDLS(description:DescriptionDto, reference:ReferenceDto): DyTOLifeSupport
		{
			var dyto:Object = new description.dytoType();
			
			//If dyto contains id property
			if(dyto.hasOwnProperty("id"))
				dyto.id = reference.id;
			
			var dls: DyTOLifeSupport = new DyTOLifeSupport(description, QueryDto.createQueryReference(reference), dyto); 
			return dls;  
		}
		
		//--------------------------------------------------------------
		//
		// Public Methods
		//
		//--------------------------------------------------------------
		/**
		 * Register properties changes 
		 * @param propertyName 
		 * @param oldValue
		 * @param newValue
		 * 
		 */		
		public function propertyChange(propertyName:String, oldValue:Object, newValue:Object):void
		{
			if (!ignoreUpdates)
			{
				LOG.debug("DyTO -> "+dyto+" property -> "+propertyName+" changes from -> "+oldValue+" to -> "+newValue);
			}
		}
		
		//--------------------------------------------------------------
		//
		// Private Methods
		//
		//--------------------------------------------------------------
		private function bindProperties():void
		{
			propertyListeners = description.bindProperties(this, dyto);
		}
		
		private function unbindPropertis(): void
		{
			var propertyListener:PropertyListener;
			
			for (var propertyName:String in propertyListeners)
			{
				propertyListener = propertyListeners[propertyName];
				propertyListener.unbind();
				
				delete propertyListeners[propertyName];
			}
		}
		
		
		//--------------------------------------------------------------
		//
		// Internal Methods
		//
		//--------------------------------------------------------------
		/**
		 * Creates DyTOs of parent dyto 
		 * 
		 */		
		internal function instantiateChildren():void
		{
			var properties:Object = description.properties;
			
			var propertyDescriptionDto:PropertyDescriptionDto;
			
			for (var propertyName:String in properties)
			{
				propertyDescriptionDto = properties[propertyName];
				
				if (propertyDescriptionDto.isDyTOList())
				{
					setNewDyTOListProperty(propertyName, DyTOListPropertyDescriptionDto(propertyDescriptionDto));
				}
				else if (propertyDescriptionDto.isDyTO())
				{
					setDyTOPropertyWithNew(propertyName, propertyDescriptionDto);
				}
				
			}
		}
		
		/**
		 * Sets DyTO child
		 * @param propertyName
		 * @param propertyDescription
		 * 
		 */		
		internal function setDyTOPropertyWithNew(propertyName: String, propertyDescription: PropertyDescriptionDto): void
		{
			LOG.debug("Create DyTO for property -> "+propertyName);
			
			dyto[propertyName] = propertyDescription.createNew();      
		}
		
		internal function setNewDyTOListProperty(propertyName:String, propertyDescription:DyTOListPropertyDescriptionDto): void
		{
			LOG.debug("Create DyTOList for property -> "+propertyName);
			// Ojo, esto no trata casos en que el backend modifique la colección
			// En teoria los elementos de la colección se actualizan
			//if (!dyto.hasOwnProperty(propertyName) || dyto[propertyName])
			//	return;
			
			//var dispatchWhenAsign:Boolean = false;
			
			var collectionQueryDto:QueryDto = QueryDto.createCollectionReference(query, propertyDescription.path);

			var dytoList: DyTOList = new DyTOList(collectionQueryDto, propertyDescription);
			
			//if(state) 	
			//	dytoList.doLoadPage(0, state[propertyName]);
			
			dyto[propertyName] = dytoList;
		}
	}
}