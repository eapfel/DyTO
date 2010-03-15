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

package org.dyto.service
{
	import flash.utils.getQualifiedClassName;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.dyto.description.DescriptionDto;
	import org.dyto.description.factory.DescriptionFactory;
	import org.dyto.description.factory.impl.DescriptionFactoryImpl;
	import org.dyto.dls.DyTOLifeSupport;
	import org.dyto.exception.DyTOError;
	import org.dyto.reference.ReferenceDto;
	
	/**
	 * @author Ezequiel
	 * @date Mar 14, 2010
	 * @since 	
	 */
	public class DyTOServiceImpl
	{
		/**
		 * LOG 
		 */		
		static private const LOG:ILogger = Log.getLogger("org.dyto.service.DyTOServiceImpl");
		
		/**
		 * Description factory 
		 */		
		static private var descriptionFactory:DescriptionFactory = new DescriptionFactoryImpl();
		
		/**
		 * Creates a new transient dyto 
		 * @return new Dyto
		 */		
		static public function createNew(dytoType:Class):Object
		{
			var description:DescriptionDto = descriptionFactory.descriptionFor(dytoType);
			
			if (!description)
				throw new DyTOError("DyTOClass "+getQualifiedClassName(dytoType)+" not mapped, verify if DyTOClass(alias=\"package.yourremoteclass\") metadata is setted");
			
			var reference:ReferenceDto = ReferenceDto.createNewTransientReference(description.remoteClassName);
			
			return DyTOLifeSupport.createTransientDyTO(description,reference);
		}
	}
}