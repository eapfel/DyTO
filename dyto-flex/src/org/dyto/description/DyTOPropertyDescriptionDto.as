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
	import org.dyto.service.DyTOServiceImpl;
	
	/**
	 * @author Ezequiel
	 * @date Mar 12, 2010
	 * @since 0.1	
	 */
	public class DyTOPropertyDescriptionDto extends PropertyDescriptionDto
	{
		/**
		 * Determines whether the property is lazy
		 * @default false  
		 */  
		public var lazy:Boolean = false;
		
		/**
		 * The class type in flex 
		 */  
		public var dytoType:Class;
		
		/**
		 * Dyto Description 
		 */		
		public var descriptionDto:DescriptionDto;
		
		/**
		 * @inheritDoc 
		 */
		override public function createNew():Object
		{
			return DyTOServiceImpl.createNew(dytoType);
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function isDyTO():Boolean
		{
			return true;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function isDyTOList():Boolean
		{
			return false;
		}
	}
}