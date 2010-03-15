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
package org.dyto.description.factory
{
	import org.dyto.description.DescriptionDto;
	
	/**
	 * @author Ezequiel
	 * @date Mar 7, 2010
	 * @since 0.1	
	 */
	public interface DescriptionFactory
	{
		/**
		 * Generates the class' description
		 * 
		 * @param dytoClass The class to assemble the description
		 * @return a DescriptionDto 
		 * 
		 * @see org.dyto.description.DescriptionDto
		 */		
		function descriptionFor(dytoClass:Class):DescriptionDto;
		
	}
}