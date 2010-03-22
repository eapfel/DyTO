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
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.dyto.DyTOs;
	import org.dyto.description.DescriptionDto;
	import org.dyto.description.PropertyDescriptionDto;
	import org.dyto.list.DyTOList;
	import org.dyto.namespaces.dyto;
	import org.dyto.reference.QueryDto;
	import org.dyto.uow.UnitOfWork;
	import org.dyto.uow.UpdateCommand;
	
	use namespace dyto;
	
	/**
	 * @author Ezequiel
	 * @date Mar 14, 2010
	 * @since 0.1	
	 */
	public class DyTOLifeSupportBase
	{
		/**
		 * LOG 
		 */		
		static private const LOG:ILogger = Log.getLogger("org.dyto.dls.DyTOLifeSupportBase");
		
		/**
		 * Description 
		 */		
		public var description:DescriptionDto;
		
		/**
		 * Dyto 
		 */		
		public var dyto:Object;
		
		/**
		 * Query 
		 */		
		public var query:QueryDto
		
		/**
		 * Controls Dytos chages 
		 */		
		protected var unitOfWork:UnitOfWork = new UnitOfWork();
		
		/**
		 * @constructor 
		 * @param _description
		 * @param _query
		 */		
		public function DyTOLifeSupportBase(_description:DescriptionDto, _query:QueryDto)
		{
			description = _description;
			query = _query;
		}
		
		//--------------------------------------------------------------
		//
		// Public Methods
		//
		//--------------------------------------------------------------
		
		/**
		 * Add command to control log
		 * 
		 * @param commandDto a CommandDto
		 */		
		public function log(commandDto:UpdateCommand):void
		{
			unitOfWork.add(commandDto);
		}
		
		/**
		 * Consolidates all commandLog of the tree
		 *  
		 * @return a consolidated commandlog collection
		 * 
		 */		
		public function consolidateCommandLogs(alreadyVisited:Object = null):ArrayCollection
		{
			
			LOG.debug("ConsolidateCommandLogs for -> "+dyto);
			
			//Gets commandlog
			var commandLog:Array = unitOfWork.getCommandLog();
			
			//Dyto properties
			var properties:Object = description.properties;
			
			var propertyDescriptionDto:PropertyDescriptionDto, dytoChild:Object, reference:String, childCommandLog:ArrayCollection;
			
			if (!alreadyVisited)
			{
				alreadyVisited = {}
				
					//Add to history visited
				reference = DyTOs.getReferenceFor(dyto).toString();	
				alreadyVisited[reference] = true;	
			}
			
			//If a property is dyto we need the commandlog to consolidate
			for (var propertyName:String in properties)
			{
				if (dyto.hasOwnProperty(propertyName) && dyto[propertyName])
				{
					 
					propertyDescriptionDto = properties[propertyName];
					
					if (propertyDescriptionDto.isDyTO())
					{
						dytoChild = dyto[propertyName];
						
						reference = DyTOs.getReferenceFor(dytoChild).toString();
						
						//to avoid circularity
						if (!alreadyVisited.hasOwnProperty(reference))
						{
							alreadyVisited[reference] = true;
							childCommandLog = DyTOs.getSupportFor(dytoChild).consolidateCommandLogs(alreadyVisited);
							
							commandLog = commandLog.concat(childCommandLog.toArray());
						}
						else
						{
							LOG.debug(dytoChild+" Already visited");
						}
					}
					
					if (propertyDescriptionDto.isDyTOList())
					{
						commandLog = commandLog.concat(DyTOList(dyto[propertyName]).consolidateCommandLogs(alreadyVisited));
					}	
				}	
			}
			
			LOG.debug("ConsolidateCommandLogs commandLog.lenght -> "+commandLog.length);
			
			return new ArrayCollection(commandLog);
		}
		
	}
}