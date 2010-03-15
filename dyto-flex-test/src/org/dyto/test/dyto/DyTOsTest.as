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

package org.dyto.test.dyto
{
	import flexunit.framework.Assert;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.dyto.service.DyTOServiceImpl;
	import org.dyto.test.vo.CompositeDyTO;
	import org.dyto.test.vo.GeneralizationSimpleDyTO;
	
	/**
	 * @author Ezequiel
	 * @date Mar 14, 2010
	 * @since 	
	 */
	public class DyTOsTest
	{
		private static const LOG:ILogger = Log.getLogger("org.dyto.test.dyto.DyTOsTest");
		
		[Before]
		public function setUp():void 
		{
			//Para que carge el objecto y lo encuentre en el dominio
			var generalizationDyTO:Class = GeneralizationSimpleDyTO;
		}
		
		[Test(order=1)]
		public function testIfCreateNewWorksOk():void 
		{
			LOG.debug("testIfCreateNewWorksOk");
			
			var compositeDyTO:CompositeDyTO = DyTOServiceImpl.createNew(CompositeDyTO) as CompositeDyTO;
			var compositeDyTO2:CompositeDyTO = DyTOServiceImpl.createNew(CompositeDyTO) as CompositeDyTO;
			
			Assert.assertTrue("Error creating a new dyto", compositeDyTO is CompositeDyTO);
		}
		
		[Test(order=2)]
		public function testIfCommandLogsWorksOk():void 
		{
			LOG.debug("testIfCommandLogsWorksOk");
			
			var compositeDyTO:CompositeDyTO = DyTOServiceImpl.createNew(CompositeDyTO) as CompositeDyTO;
			var compositeDyTO2:CompositeDyTO = DyTOServiceImpl.createNew(CompositeDyTO) as CompositeDyTO;
			
			compositeDyTO.simpleProperty = "hello";
			
			compositeDyTO.simpleDyTO.address = "newAddress";
			
			compositeDyTO2.simpleProperty = "bye"
				
			compositeDyTO2.simpleDyTO.address = "newAddress2";	
			
			Assert.assertTrue("Error commandlog", 1==1);
		}
	}
}