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

package org.dyto.listener
{
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.dyto.dls.DyTOLifeSupport;
	
	/**
	 * @author Ezequiel
	 * @date Mar 14, 2010
	 * @since 0.1 	
	 */
	public class PropertyListener
	{
		/**
		 * Log 
		 */		
		static private const LOG:ILogger = Log.getLogger("org.dyto.listener.PropertyListener");
		
		/**
		 * dyto property's name 
		 */		
		public var propertyName:String;
		
		/**
		 * dls 
		 */		
		public var dls:DyTOLifeSupport;
		
		/**
		 * Changes Watcher 
		 */		
		private var changeWatcher:ChangeWatcher;
		
		/**
		 * Old Value 
		 */		
		private var oldValue:Object;
		
		public function PropertyListener(_propertyName:String, _dls:DyTOLifeSupport)
		{
			propertyName = _propertyName;
			
			dls = _dls;
		}
		
		//--------------------------------------------------------------
		//
		// Public Methods
		//
		//--------------------------------------------------------------
		/**
		 * Bind the property with watcher 
		 */		
		public function bind():void 
		{
			changeWatcher = BindingUtils.bindSetter(propertyChanged, dls.dyto, propertyName);
			oldValue = dls.dyto[propertyName];
		}
		
		public function unbind():void
		{
			changeWatcher.unwatch();
			changeWatcher = null;
		}	
		
		/**
		 * Property change handler  
		 * @param value new value
		 */		
		public function propertyChanged(newValue:Object):void
		{
			if (checkValueChanged(newValue))
			{
				dls.propertyChange(propertyName, oldValue, newValue);
				oldValue = newValue;
			}
		}
		
		//--------------------------------------------------------------
		//
		// Private Methods
		//
		//--------------------------------------------------------------
		/**
		 * Check whether the newValue changed
		 * @param newValue
		 * @return true if newValue has change otherwise false
		 * 
		 */		
		private function checkValueChanged(newValue:Object):Boolean
		{
			var changed: Boolean = false;
			
			if(newValue != oldValue)
			{
				if(empty(newValue) && empty(oldValue))
				{
					changed = false;
				}
				else if(oldValue is Date)
				{
					if(!(empty(newValue) || empty(oldValue)))
					{
						var oldDate: Date = oldValue as Date;
						var newDate: Date = newValue as Date;
						changed = oldDate.getTime() != newDate.getTime();
					}
					else
						changed = false;
				}
				else
				{
					changed = true;
				}
			}
			return changed;
		}
		
		/**
		 * Check if value is empty
		 * @param value
		 * @return true if value is empty otherwise false 
		 * 
		 */		
		private function empty(value:Object): Boolean
		{
			if(!value)
				return true;
			else if(value is Number)
				return isNaN(Number(value)) || value == 0;
			else if(value is int)
				return isNaN(int(value)) || value == 0;
			else 
				return false;
		}
	}
}