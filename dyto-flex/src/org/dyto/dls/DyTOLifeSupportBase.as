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
	import org.dyto.description.DescriptionDto;
	import org.dyto.reference.QueryDto;
	
	/**
	 * @author Ezequiel
	 * @date Mar 14, 2010
	 * @since 0.1	
	 */
	public class DyTOLifeSupportBase
	{
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
		 * @constructor 
		 * @param _description
		 * @param _query
		 */		
		public function DyTOLifeSupportBase(_description:DescriptionDto, _query:QueryDto)
		{
			description = _description;
			query = _query;
		}
		
	}
}