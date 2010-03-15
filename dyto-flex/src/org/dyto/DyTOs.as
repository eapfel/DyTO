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

package org.dyto
{
	import flash.utils.Dictionary;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.dyto.dls.DyTOLifeSupport;
	import org.dyto.reference.ReferenceDto;
	
	/**
	 * @author Ezequiel
	 * @date Mar 14, 2010
	 * @since 0.1 	
	 */
	public class DyTOs
	{
		/**
		 * LOG 
		 */		
		static private const LOG:ILogger = Log.getLogger("org.dyto.DyTOs");
	
		/**
		 * Map that contains a dyto's reference against a dls 
		 */		
		static private var dytoDLSRegistry:Dictionary = new Dictionary(true);
		
		/**
		 * Map that contains a refereceDto's reference against a dls 
		 */		
		static private var referencesDLSRegistry:Dictionary = new Dictionary(true);
		
		//--------------------------------------------------------------
		//
		// Static Public Methods
		//
		//--------------------------------------------------------------
		/**
		 *  Register dls in registry
		 * @param dyto
		 * @param dls
		 * 
		 */		
		static public function registerDLS(dyto:Object, dls:DyTOLifeSupport):void
		{
			dytoDLSRegistry[dyto] = dls;
			
			referencesDLSRegistry[dls.query.reference] = dls;
		}
		
		/**
		 * Gets a DyTOLifeSupport 
		 * @param dyto
		 * @return 
		 * 
		 */		
		static public function getSupportFor(dyto:Object):DyTOLifeSupport
		{
			return dytoDLSRegistry[dyto];
		}
		
		/**
		 * Gets a ReferenceDto 
		 * @param dyto
		 * @return 
		 * 
		 */		
		static public function getReferenceFor(dyto:Object):ReferenceDto
		{
			return getSupportFor(dyto).query.reference;
		}
	}
}