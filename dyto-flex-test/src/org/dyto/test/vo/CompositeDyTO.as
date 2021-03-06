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

package org.dyto.test.vo
{
	import mx.collections.IList;

	[Bindable]
	[DyTOClass(alias="org.dyto.domain.Composite")]
	/**
	 * @author Ezequiel
	 * @date Mar 12, 2010
	 * @since 0.1 	
	 */
	public class CompositeDyTO
	{
		[DyTOProperty(lazy="true", path="simple.path")]
		public var simpleDyTO:SimpleDyTO;
		
		[DyTOProperty]
		public var otherSimpleDyTO:SimpleDyTO;
		
		[DyTOProperty]
		public var circularDyto:CircularSourceDyTO;
		
		[DyTOProperty(dyto="org.dyto.test.vo::SimpleDyTO")]
		public var aDefaultDytoList:IList;
		
		[DyTOProperty(lazy="true",pageSize="10", dyto="org.dyto.test.vo::GeneralizationSimpleDyTO")]
		public var aDytoList:IList;
		
		public var simpleProperty:String;
	}
}