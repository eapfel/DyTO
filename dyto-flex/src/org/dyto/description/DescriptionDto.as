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

package org.dyto.description
{
	import flash.utils.Dictionary;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.dyto.dls.DyTOLifeSupport;
	
	/**
	 * Contains the remote class' properties
	 * 
	 * @author Ezequiel
	 * @date Mar 3, 2010
	 * @since 0.1	
	 */
	public class DescriptionDto
	{
		/**
		 * Log 
		 */		
		static private const LOG:ILogger = Log.getLogger("org.dyto.description.DescriptionDto");
		
		/**
		 * Remote class name
		 * e.g: package.domain.AClass 
		 */		
		public var remoteClassName:String;
		
		/**
		 * The class type in flex 
		 */  
		public var dytoType:Class;
		
		/**
		 * Class' properties that are mapped
		 */		
		public var properties:Object = {};
		
		
		/**
		 * Bind properties 
		 * @param dls
		 * @param dyto
		 * @return Dictionary of listenes
		 * 
		 */		
		public function bindProperties(dls:DyTOLifeSupport, dyto:Object):Dictionary
		{
			var propertyListeners:Dictionary = new Dictionary(true);
			
			var propertyDescription:PropertyDescriptionDto;
			
			LOG.debug("Bind properties for dyto -> "+dyto);
			
			for (var propertyName:String in properties)
			{
				if (dyto.hasOwnProperty(propertyName))
				{
					propertyDescription = properties[propertyName]
					
					if (!propertyDescription.isDyTOList())
					{
						propertyListeners[propertyName] = propertyDescription.bind(propertyName, dls);;
					}
				}
				else
				{
					LOG.debug("Property -> "+propertyName+" dosen't exist to bind with-> "+dyto);  
				}
			}
			
			return propertyListeners;
		}
	}
}