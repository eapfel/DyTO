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
	import org.dyto.DyTOs;
	import org.dyto.description.factory.impl.DyTOFactory;
	import org.dyto.reference.QueryDto;
	import org.dyto.uow.UpdateCommand;
	import org.dyto.uow.UpdateDyTOCommand;
	import org.dyto.namespaces.dyto;
	
	use namespace dyto;
	
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
		override public function createNew(from:Object):Object
		{
			return DyTOFactory.innerCreateNew(dytoType, from);
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
		
		override public function createUpdateCommand(query:QueryDto, oldValue:Object, newValue:Object):UpdateCommand
		{
			var cmd:UpdateDyTOCommand = super.createUpdateCommand(query, oldValue, newValue) as UpdateDyTOCommand;
			
			if(newValue != null)
				cmd.valueQuery = QueryDto.createReference(DyTOs.getReferenceFor(newValue));
			
			return cmd;
		}
		
		override protected function innerCreateUpdateCommand():UpdateCommand
		{
			return new UpdateDyTOCommand();
		}
	}
}