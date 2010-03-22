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
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.dyto.DyTOs;
	import org.dyto.description.factory.impl.DyTOFactory;
	import org.dyto.test.vo.AtoB;
	import org.dyto.test.vo.BtoC;
	import org.dyto.test.vo.CircularDestinationDyTO;
	import org.dyto.test.vo.CircularSourceDyTO;
	import org.dyto.test.vo.CompositeDyTO;
	import org.dyto.test.vo.CtoA;
	import org.dyto.test.vo.GeneralizationSimpleDyTO;
	import org.dyto.test.vo.SimpleDyTO;
	
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
			LOG.debug("=============================================");
			LOG.debug("testIfCreateNewWorksOk");
			
			var compositeDyTO:CompositeDyTO = DyTOFactory.createNew(CompositeDyTO) as CompositeDyTO;
			
			Assert.assertTrue("Error creating a new dyto", compositeDyTO is CompositeDyTO);
		}
		
		[Test(order=2)]
		public function testIfCommandLogsWorksOk():void 
		{
			LOG.debug("=============================================");
			LOG.debug("testIfCommandLogsWorksOk");
			
			/*
			* Espero un comando por cada dyto que se crea en inistatiateChilder dentro de DyTOLifeSopport
			* y un comando por cada property que se cambia
			* CopompositeDyTO tiene 4 comandos
			*/
			var compositeDyTO:CompositeDyTO = DyTOFactory.createNew(CompositeDyTO) as CompositeDyTO;
			
			//Command 1
			compositeDyTO.simpleProperty = "hello";
			
			//Command 2
			compositeDyTO.simpleDyTO = DyTOFactory.createNew(SimpleDyTO) as SimpleDyTO;
			//Command 3
			compositeDyTO.simpleDyTO.address = "newAddress";
			
			//Command 4
			compositeDyTO.circularDyto = DyTOFactory.createNew(CircularSourceDyTO) as CircularSourceDyTO;
			//Command 5
			compositeDyTO.circularDyto.aProperty = "aPropertyChange";
			
			//Command 6
			compositeDyTO.circularDyto.circularDestination = DyTOFactory.createNew(CircularDestinationDyTO) as CircularDestinationDyTO;
			//Command 7
			compositeDyTO.circularDyto.circularDestination.aProperty = "aPropertyChange";
			
			//Command 8
			compositeDyTO.circularDyto.circularDestination.circularSource = compositeDyTO.circularDyto;
			//replace command 5
			compositeDyTO.circularDyto.circularDestination.circularSource.aProperty = "aPropertyChangeAgain";
			
			//Command 9 create AddCommand
			compositeDyTO.aDytoList.addItem(DyTOFactory.createNew(GeneralizationSimpleDyTO));
			
			//Command 10 create AddCommand
			compositeDyTO.aDytoList.addItem(DyTOFactory.createNew(GeneralizationSimpleDyTO));
			
			//Command 11 create RemoveCommand
			compositeDyTO.aDytoList.removeItemAt(1);
			
			var commandLog:ArrayCollection = DyTOs.getSupportFor(compositeDyTO).consolidateCommandLogs();
			
			Assert.assertTrue("Error commandlog expected 11, obteins "+commandLog.length , 11==commandLog.length);
		}
		
		[Test(order=3)]
		public function testIfCommandLogs3CircularWorksOk():void 
		{
			LOG.debug("=============================================");
			LOG.debug("testIfCommandLogs3CircularWorksOk");
			
			var atob:AtoB = DyTOFactory.createNew(AtoB) as AtoB;
			
			atob.btoc = DyTOFactory.createNew(BtoC) as BtoC;
			
			atob.btoc.ctoa = DyTOFactory.createNew(CtoA) as CtoA;
			
			atob.btoc.ctoa.atob = atob;
			
			var commandLog:ArrayCollection = DyTOs.getSupportFor(atob).consolidateCommandLogs();
			
			Assert.assertTrue("Error commandlog expected 3, obteins "+commandLog.length , 3==commandLog.length);
			
		}
	}
}