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

package org.dyto.reference
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	/**
	 * Represents the remote class' reference (id+version)
	 * @author Ezequiel
	 * @date Mar 14, 2010
	 * @since 0.1	
	 */
	public class ReferenceDto
	{
		static private const LOG:ILogger = Log.getLogger("org.dyto.reference.ReferenceDto");
		/**
		 * Last id setted 
		 */		
		static private var _nextID:Number = -1;
		
		/**
		 * Remote Class Name 
		 */		
		public var className:String;
		
		/**
		 * Identity 
		 */		
		public var id:Number;
		
		/**
		 * Version 
		 */		
		public var version:Number;
		
		/**
		 * Creates a new transient dyto 
		 * @param className
		 * @return 
		 * 
		 */		
		static public function createNewTransientReference(className:String):ReferenceDto
		{
			var reference:ReferenceDto = new ReferenceDto();
			
			reference.className = className;
			
			reference.id = nextID;
			
			reference.version = 0;
			
			LOG.debug("Creates new trancient reference -> "+reference);
			
			return reference;
		}
		
		public function toString():String
		{
			return className+"("+id+"/"+version+")";
		}			
		
		/**
		 * Gets nextid 
		 * @return 
		 * 
		 */		
		static internal function get nextID():Number
		{
			return _nextID--;
		}
	}
}