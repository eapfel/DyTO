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

package org.dyto.exception
{
	
	/**
	 * This is the base class for any dyto mapping related error.
 	 * It allows for less granular catch code.
	 * 
	 * @author Ezequiel
	 * @date Mar 14, 2010
	 * @since 0.1	
	 */
	public class DyTOMappingError extends Error
	{
		public function DyTOMappingError(message:String)
		{
			super(message);
		}
		
		/**
		 *  Returns the string "[DyTOMappingError]" by default, and includes the message property if defined.
		 * 
		 *  @return String representation of the DyTOMappingError.
		 *  
		 */
		public function toString():String
		{
			var value:String = "[DyTOMappingError";
			if (message != null)
				value += " message='" + message + "']";
			else
				value += "]";
			return value;
		}
	}
}