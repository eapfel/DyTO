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

package org.dyto.list
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.core.IPropertyChangeNotifier;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.utils.ArrayUtil;
	import mx.utils.UIDUtil;
	
	import org.dyto.DyTOs;
	import org.dyto.description.DescriptionDto;
	import org.dyto.description.DyTOListPropertyDescriptionDto;
	import org.dyto.dls.DyTOLifeSupportBase;
	import org.dyto.exception.DyTOError;
	import org.dyto.namespaces.dyto;
	import org.dyto.reference.QueryDto;
	import org.dyto.reference.ResultConfigDto;
	import org.dyto.uow.AddCommand;
	import org.dyto.uow.RemoveCommand;
	
	use namespace dyto;
	
	/**
	 * @author Ezequiel
	 * @date Mar 15, 2010
	 * @since 0.1	
	 */
	[Bindable]
	public class DyTOList extends EventDispatcher implements IList, IPropertyChangeNotifier
	{
		//TODO: Falta toda la parte de carga de dyto
	  /**
		 *  @private 
		 *  Indicates if events should be dispatched.
		 *  calls to enableEvents() and disableEvents() effect the value when == 0
		 *  events should be dispatched. 
		 */
		private var _dispatchEvents:int = 0;
		
		/**
		 *  @private
		 *  Used for accessing localized Error messages.
		 */
		private var resourceManager:IResourceManager = ResourceManager.getInstance();
		
		/**
		 *  @private
		 *  Storage for the source Array.
		 */
		private var _source:Array;

		/**
		 *  @private
		 *  Storage for the UID String. 
		 */
		private var _uid:String;
		
		/**
		 * 
		 */		
		private var _hasMoreElements:Boolean = false;
		
		/**
		 * 
		 */		
		private var _toAddWhenLoaded:Array;
		
		/**
		 * 
		 */		
		private var _dls:DyTOLifeSupportBase;
		
		/**
		 * 
		 */		
		private var _sourceQuery:QueryDto;
		
		/**
		 * 
		 */		
		private var _elementDescriptionDto:DescriptionDto;
		
		/**
		 * 
		 */		
		private var _dytoType:Class;
		
		/**
		 * 
		 */		
		private var _resultConfig:ResultConfigDto;
		
		/**
		 * Construct a new ArrayList
		 * 
		 */		
		public function DyTOList(query:QueryDto, propertyDescription:DyTOListPropertyDescriptionDto)
		{
			super();
			
			_sourceQuery = query;
			
			_dls = new DyTOLifeSupportBase(propertyDescription.descriptionDto, query);
			_dls.dyto = this;
			
			_resultConfig = propertyDescription.createResultConfig();
			
			_dytoType = propertyDescription.dytoType;
			
			_elementDescriptionDto = propertyDescription.descriptionDto;
			
			_source = [];
			
			_uid = UIDUtil.createUID();
			
		}
		
		public function get length():int
		{
			if (_hasMoreElements)
				return _source.length + 1
			else
				return _source.length;
		}
		
		public function addItem(item:Object):void
		{
			if (!_toAddWhenLoaded)
				_toAddWhenLoaded = [];
			
			if(_hasMoreElements)// && !completelyLoaded)
			{
					//toAddWhenLoaded = new ArrayCollection();
					//var token: AsyncToken = load();
					//token.addResponder(new DyTOGenericResponder(this, addToAddWhenLoaded));
					_toAddWhenLoaded.push(item);
			}
			else
			{
				_toAddWhenLoaded.push(item);
				doAddPending();
				//cantAgregados++;
			}
		}
		
		public function addItemAt(item:Object, index:int):void
		{
			throw new DyTOError("not implemented");
		}
		
		public function getItemAt(index:int, prefetch:int=0):Object
		{
			if(_hasMoreElements)//index>=innerList.length && !completelyLoaded)
			{
				//miss(index);
				/*var cliente: Cliente = new Cliente();
				cliente.apellido = "Cargando";*/
				return null;
				//throw new ItemPendingError("Cargando");
			}
			
			return _source[index];
		}
		
		public function getItemIndex(item:Object):int
		{
			return ArrayUtil.getItemIndex(item, _source);
		}
		
		public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void
		{
		}
		
		public function removeAll():void
		{
			if (length > 0)
			{
				var len:int = length;
				for (var i:int = 0; i < len; i++)
				{
					createRemoveCommand(_source[i]);
					
					stopTrackUpdates(_source[i]);
				}
				
				_source.splice(0, length);
				
				internalDispatchEvent(CollectionEventKind.RESET);
			}
		}
		
		public function removeItemAt(index:int):Object
		{
			if (index < 0 || index >= length)
			{
				var message:String = resourceManager.getString(
					"collections", "outOfBounds", [ index ]);
				throw new RangeError(message);
			}
			
			var removed:Object = _source.splice(index, 1)[0];
			
			createRemoveCommand(removed);
			
			stopTrackUpdates(removed);
			
			internalDispatchEvent(CollectionEventKind.REMOVE, removed, index);

			return removed;
		}
		
		public function setItemAt(item:Object, index:int):Object
		{
			throw new DyTOError("not implemented");
		}
		
		public function toArray():Array
		{
			return _source.concat();
		}
		
		public function get uid():String
		{
			return _uid;
		}
		
		public function set uid(value:String):void
		{
			_uid = value;
		}
		
		/**
		 *  Pretty prints the contents of this ArrayList to a string and returns it.
		 */
		override public function toString():String
		{
			if (_source)
				return getQualifiedClassName(this)+" " +_source.toString();
			else
				return getQualifiedClassName(this); 
		}   
		
		//--------------------------------------------------------------
		//
		// Protected Methods
		//
		//--------------------------------------------------------------
		
		/**
		 *  Called whenever any of the contained items in the list fire an
		 *  ObjectChange event.  
		 *  Wraps it in a CollectionEventKind.UPDATE.
		 */    
		protected function itemUpdateHandler(event:PropertyChangeEvent):void
		{
			internalDispatchEvent(CollectionEventKind.UPDATE, event);
			// need to dispatch object event now
			if (_dispatchEvents == 0 && hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
			{
				var objEvent:PropertyChangeEvent = PropertyChangeEvent(event.clone());
				var index:uint = getItemIndex(event.target);
				objEvent.property = index.toString() + "." + event.property;
				dispatchEvent(objEvent);
			}
		}
		
		/** 
		 *  If the item is an IEventDispatcher watch it for updates.  
		 *  This is called by addItemAt and when the source is initially
		 *  assigned.
		 */
		protected function startTrackUpdates(item:Object):void
		{
			if (item && (item is IEventDispatcher))
			{
				IEventDispatcher(item).addEventListener(
					PropertyChangeEvent.PROPERTY_CHANGE, 
					itemUpdateHandler, false, 0, true);
			}
		}
		
		/** 
		 *  If the item is an IEventDispatcher stop watching it for updates.
		 *  This is called by removeItemAt, removeAll, and before a new
		 *  source is assigned.
		 */
		protected function stopTrackUpdates(item:Object):void
		{
			if (item && item is IEventDispatcher)
			{
				IEventDispatcher(item).removeEventListener(
					PropertyChangeEvent.PROPERTY_CHANGE, 
					itemUpdateHandler);    
			}
		}
		
		
		//--------------------------------------------------------------
		//
		// Private Methods
		//
		//--------------------------------------------------------------
		
		private function doAddPending():void
		{
			var initialPosition: int = _source.length;
			var added: Array = [];
			var toAddWhenLoadedLength:int = _toAddWhenLoaded.length
			var item:Object;
			var itemDls:DyTOLifeSupportBase;
			
			for(var i:int = 0; i < toAddWhenLoadedLength; i++)
			{
				item = _toAddWhenLoaded[i];
				_source.push(item);
				
				//TODO:  Agregar esto
				itemDls = DyTOs.getSupportFor(item);
				_dls.log(AddCommand.create(_sourceQuery, itemDls.query));
				//
				
				startTrackUpdates(item);
				internalDispatchEvent(CollectionEventKind.ADD, item, i);
			}
			           
			_toAddWhenLoaded = null;
		}
		
		/**
		 *  Dispatches a collection event with the specified information.
		 *
		 *  @param kind String indicates what the kind property of the event should be
		 *  @param item Object reference to the item that was added or removed
		 *  @param location int indicating where in the source the item was added.
		 */
		private function internalDispatchEvent(kind:String, item:Object = null, location:int = -1):void
		{
			if (_dispatchEvents == 0)
			{
				if (hasEventListener(CollectionEvent.COLLECTION_CHANGE))
				{
					var event:CollectionEvent =
						new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
					event.kind = kind;
					event.items.push(item);
					event.location = location;
					dispatchEvent(event);
				}
				
				// now dispatch a complementary PropertyChangeEvent
				if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE) && 
					(kind == CollectionEventKind.ADD || kind == CollectionEventKind.REMOVE))
				{
					var objEvent:PropertyChangeEvent =
						new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
					objEvent.property = location;
					if (kind == CollectionEventKind.ADD)
						objEvent.newValue = item;
					else
						objEvent.oldValue = item;
					dispatchEvent(objEvent);
				}
			}
		}
		
		/**
		 * Create Remove Command
		 * @private 
		 */		
		private function createRemoveCommand(removed:Object):Object 
		{
			var itemDls:DyTOLifeSupportBase = DyTOs.getSupportFor(removed);
			
			_dls.log(RemoveCommand.create(_sourceQuery, itemDls.query));
			
			return removed;
		}
		
		/**
		 * Gets consolidated command logs
		 * only used on DyTO framework
		 *  
		 * @param alreadyVisited
		 * @return an array of commandlogs 
		 * 
		 */		
		dyto function consolidateCommandLogs(alreadyVisited:Object):Array
		{
			
			var commands:Array = _dls.consolidateCommandLogs(alreadyVisited).toArray();
			
			var item:Object, reference:String, childCommandLog:ArrayCollection;
			
			var len:int = _source.length;
			
			for (var i:int = 0; i < len; i++)
			{
				item = _source[i];
					
				reference = DyTOs.getReferenceFor(item).toString();
				
				if(!alreadyVisited.hasOwnProperty(reference))
				{
					alreadyVisited[reference] = true;
					
					childCommandLog = DyTOs.getSupportFor(item).consolidateCommandLogs(alreadyVisited)
					
					commands = commands.concat(childCommandLog.toArray());
				}	
			}

			return commands;
		}
	}
}