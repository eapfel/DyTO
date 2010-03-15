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

package org.dyto.metadata
{
	import org.dyto.exception.DyTOMappingError;
	
	/**
	 * @author Ezequiel
	 * @date Mar 14, 2010
	 * @since 0.1	
	 */
	public class DyTOMetadata
	{
		static private const ALIAS:String = "alias";
		
		/**
		 * Used to verify if alias="package.aClass" is correct 
		 */		
		static private const ALIAS_REGEX:RegExp = /^[(a-z)][\w|\.]*.\w+$/
		
		public var alias:String;
		
		/**
		 * Creates a DyTOMetadata 
		 */	
		static public function create(metadataInfo:XMLList, className:String):DyTOMetadata
		{
			var dytoMetadata:DyTOMetadata = new DyTOMetadata();
			
			var medatadataInfoArgs:XMLList = metadataInfo.arg;
			
			var alias:String;
			
			if (!(medatadataInfoArgs && medatadataInfoArgs.length() > 0))
				throw new DyTOMappingError("alias property must be setted for DyTOClass "+className+". e.g: DyTOClass(dyto=\"package.RemoteClass\")");
			
		 	alias = MetadataUtils.getStringValueOrDefault(ALIAS,medatadataInfoArgs,null);
		
		 	if (!alias)
			 throw new DyTOMappingError("alias property must be setted for DyTOClass "+className+". e.g: DyTOClass(dyto=\"package.RemoteClass\")");
		 
		 	if (alias.search(ALIAS_REGEX) == -1)
			 throw new DyTOMappingError("alias property "+alias+" malformed for DyTOClass "+className+". e.g: package.RemoteClass");
		 
		 	dytoMetadata.alias = alias ;
			 
			return dytoMetadata;
		}
		
		public function toString():String
		{
			return "DyTOClass(alias="+alias+")";
		}
	}
}