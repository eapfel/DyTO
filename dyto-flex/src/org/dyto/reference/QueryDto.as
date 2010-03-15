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
	
	/**
	 * @author Ezequiel
	 * @date Mar 14, 2010
	 * @since 0.1	
	 */
	public class QueryDto
	{
		static private const REFERENCE_DISCRIMINATOR:String = "com.cubika.base.repository.Reference";
		static private const COLLECTION_REFERENCE_DISCRIMINATOR:String = "com.cubika.base.repository.queries.CollectionReference";
		
		/**
		 * Reference 
		 */		
	 	public var reference:ReferenceDto;
		
		/**
		 * Discriminator 
		 */		
		public var discriminator:String;
		
		// CollectionReference  
		public var collectionReferenceRootReference: QueryDto;
		public var collectionReferencePathFromRoot: String;
		
		/**
		 * Creates a QueryDto reference 
		 * @param reference
		 * @return new QueryDto
		 * 
		 */		
		static public function createQueryReference(reference:ReferenceDto):QueryDto
		{
			var query:QueryDto = new QueryDto();
			query.discriminator = REFERENCE_DISCRIMINATOR;
			query.reference = reference;
			
			return query;
		}
		
		/**
		 * Creates a QueryDto for DyTOList 
		 * @param rootRef
		 * @param pathFromRoot
		 * @return 
		 * 
		 */		
		static public function createCollectionReference(rootRef:QueryDto, pathFromRoot:String): QueryDto
		{
			var query: QueryDto = new QueryDto();
			
			query.discriminator = COLLECTION_REFERENCE_DISCRIMINATOR;
			query.collectionReferenceRootReference = rootRef;
			query.collectionReferencePathFromRoot = pathFromRoot;
			
			return query;
		}
	}
}