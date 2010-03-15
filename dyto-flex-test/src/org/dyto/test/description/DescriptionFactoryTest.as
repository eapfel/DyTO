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

package org.dyto.test.description
{
	import flexunit.framework.Assert;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.ObjectUtil;
	
	import org.dyto.description.DescriptionDto;
	import org.dyto.description.DyTOListPropertyDescriptionDto;
	import org.dyto.description.DyTOPropertyDescriptionDto;
	import org.dyto.description.factory.DescriptionFactory;
	import org.dyto.description.factory.impl.DescriptionFactoryImpl;
	import org.dyto.test.vo.CircularSourceDyTO;
	import org.dyto.test.vo.CompositeDyTO;
	import org.dyto.test.vo.GeneralizationSimpleDyTO;
	import org.dyto.test.vo.SimpleDyTO;
	import org.dyto.test.vo.TreeDyTO;
	
	/**
	 * @author Ezequiel
	 * @date Mar 7, 2010
	 * @since 0.1	
	 */
	public class DescriptionFactoryTest
	{
		static private const LOG:ILogger = Log.getLogger("org.dyto.test.description.DescriptionFactoryTest")
		protected var descriptionDtoFactory:DescriptionFactory;
		
		[Before]
		public function setUp():void 
		{
			descriptionDtoFactory = new DescriptionFactoryImpl();
		}
		
		[After]  
		public function tearMeDown():void  
		{  
			descriptionDtoFactory = null;  
		}
		
		[Test(order=1)]
		public function testIfClassNameIsCorrect():void
		{
			LOG.debug("testIfClassNameIsCorrect");
				
			var descriptionDto:DescriptionDto = null;
			
			descriptionDto = descriptionDtoFactory.descriptionFor(SimpleDyTO);
			
			Assert.assertTrue("Incorrect dytoType",descriptionDto.dytoType == SimpleDyTO);
			
			Assert.assertTrue("Incorrect name, expected org.dyto.domain.Simple",descriptionDto.remoteClassName == "org.dyto.domain.Simple");
		}
		
		[Test(order=2)]
		public function testIfNumberOfPropertiesIsCorrect():void
		{
			LOG.debug("testIfNumberOfPropertiesIsCorrect");
			
			var descriptionDto:DescriptionDto = null;
			
			descriptionDto = descriptionDtoFactory.descriptionFor(SimpleDyTO);
			
			var description:Object = ObjectUtil.getClassInfo(descriptionDto.properties);
			
			// Add your test logic here
			Assert.assertTrue("Incorrect properties number, expected 5 but the object contains "+description.properties.length ,description.properties.length == 5);
		}
		
		[Test(order=3)]
		public function testIfNumberOfPropertiesIsCorrectInGeneralizationClass():void
		{
			LOG.debug("testIfNumberOfPropertiesIsCorrectInGeneralizationClass");
			
			var descriptionDto:DescriptionDto = null;
			
			descriptionDto = descriptionDtoFactory.descriptionFor(GeneralizationSimpleDyTO);
			
			var description:Object = ObjectUtil.getClassInfo(descriptionDto.properties);
			
			// Add your test logic here
			Assert.assertTrue("Incorrect properties number, expected 6 but the object contains "+description.properties.length ,description.properties.length == 6);
		}
		
		[Test(order=4)]
		public function testIfCompositeDyTOPropertiesIsOk():void
		{
			LOG.debug("testIfCompositeDyTOPropertiesIsOk");
			
			var descriptionDto:DescriptionDto = null;
			
			descriptionDto = descriptionDtoFactory.descriptionFor(CompositeDyTO);
			
			var description:Object = ObjectUtil.getClassInfo(descriptionDto.properties);
			
			var propertyDescription:DyTOPropertyDescriptionDto = descriptionDto.properties["simpleDyTO"]
			
			var descriptionDtoSimpleDyTO:DescriptionDto = propertyDescription.descriptionDto;
			
			var descriptionSimpleDyTO:Object = ObjectUtil.getClassInfo(descriptionDtoSimpleDyTO.properties);
			
			// Add your test logic here
			Assert.assertTrue("Incorrect lazy, expected true but obteins "+propertyDescription.lazy ,propertyDescription.lazy == true);
			Assert.assertTrue("Incorrect path, expected simple.path but obteins "+propertyDescription.path ,propertyDescription.path == "simple.path");
			Assert.assertTrue("Incorrect properties number, expected 5 but the object contains "+description.properties.length ,description.properties.length == 5);
			Assert.assertTrue("Incorrect properties number, expected 5 but the object contains "+descriptionSimpleDyTO.properties.length ,descriptionSimpleDyTO.properties.length == 5);
		}
		
		[Test(order=5)]
		public function testIfCompositeDyTOListPropertiesIsOk():void
		{
			LOG.debug("testIfCompositeDyTOListPropertiesIsOk");
			
			var descriptionDto:DescriptionDto = null;
			
			descriptionDto = descriptionDtoFactory.descriptionFor(CompositeDyTO);
			
			var aDyTOListDescription:DyTOListPropertyDescriptionDto = descriptionDto.properties["aDytoList"]
			
			var aDefaultDytoListDescription:DyTOListPropertyDescriptionDto = descriptionDto.properties["aDefaultDytoList"]
			
			// Add your test logic here
			Assert.assertTrue("Incorrect lazy, expected true but obteins "+aDyTOListDescription.lazy ,aDyTOListDescription.lazy == true);
			Assert.assertTrue("Incorrect lazy, expected false but obteins "+aDefaultDytoListDescription.lazy ,aDefaultDytoListDescription.lazy == false);
			Assert.assertTrue("Incorrect pageSize, expected 10 but obteins "+aDyTOListDescription.pageSize ,aDyTOListDescription.pageSize == 10);
			Assert.assertTrue("Incorrect lazy, expected 20 but obteins "+aDefaultDytoListDescription.pageSize ,aDefaultDytoListDescription.pageSize == 20);
			
		}
		
		[Test(order=6)]
		public function testIfTreeDyTOisOk():void
		{
			LOG.debug("testIfTreeDyTOisOk");
			
			var descriptionDto:DescriptionDto = null;
			
			descriptionDto = descriptionDtoFactory.descriptionFor(TreeDyTO);
			
			var description:Object = ObjectUtil.getClassInfo(descriptionDto.properties);
			
			var parentDescription:DyTOPropertyDescriptionDto = descriptionDto.properties["parent"]
			
			var childrenDescription:DyTOListPropertyDescriptionDto = descriptionDto.properties["children"]
			
			// Add your test logic here
			Assert.assertTrue("Incorrect properties number, expected 2 but the object contains "+description.properties.length ,description.properties.length == 2);
			
		}
		
		[Test(order=7)]
		public function testIfCircularDyTOWorksOk():void
		{
			LOG.debug("testIfCircularDyTOWorksOk");
			
			var descriptionDto:DescriptionDto = null;
			
			descriptionDto = descriptionDtoFactory.descriptionFor(CircularSourceDyTO);
			
			var description:Object = ObjectUtil.getClassInfo(descriptionDto.properties);
			
			// Add your test logic here
			Assert.assertTrue("Incorrect properties number, expected 2 but the object contains "+description.properties.length ,description.properties.length == 2);
			
		}
	}
}