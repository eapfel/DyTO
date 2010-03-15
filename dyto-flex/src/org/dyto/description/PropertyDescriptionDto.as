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
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.dyto.dls.DyTOLifeSupport;
	import org.dyto.exception.DyTOError;
	import org.dyto.listener.PropertyListener;

	/**
	 * @author Ezequiel
	 * @date Mar 11, 2010
	 * @since 0.1 	
	 */
	public class PropertyDescriptionDto
	{
		static private const LOG:ILogger = Log.getLogger("org.dyto.description.PropertyDescriptionDto");
		/**
		 * Path to the property on the server 
		 */  
		public var path:String;
		
		public function bind(propertyName:String, dls:DyTOLifeSupport):PropertyListener
		{
			LOG.debug("Bind property -> "+propertyName);
			
			var propertyListener:PropertyListener = new PropertyListener(propertyName,dls);
			
			propertyListener.bind();
			
			return propertyListener;
		}
		
		/**
		 * Creates new Dyto 
		 */
		public function createNew():Object
		{
			throw new DyTOError("must be override");
		}
		
		/**
		 * determines whether the property is a dyto object 
		 */		
		public function isDyTO():Boolean
		{
			return false;
		}
		
		/**
		 * determines whether the property is a list dyto 
		 */		
		public function isDyTOList():Boolean
		{
			return false;
		}
	}
}