package flexmapeditor.vo {
	
	import mx.collections.ArrayCollection;
	
	/**
	 *	Proxy TriggerProperties
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  19.07.2010
	 */
	
	[Bindable]
	public class TriggerProperties {

		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static var fireTypes:ArrayCollection;
		public static var triggerClasses:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function TriggerProperties (o:Object)
		{
			
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _ot:Object;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne l'intitulé d'une classe de trigger
		 * @param	id	 identifiant de la calsse trigger
		 */
		public static function getTriggerClassLabel (id:int) : String {
			return triggerClasses[id];
		}
		
		/*public function get inactiveFromMaps () : Array {
			return 
		}*/
		
/*		public var id:int;
		public var fireType:int;
		public var triggerClass:int;
		public var targetObject:Object;*/
//		public var arguments:Dictionary;
		
//		public function get id () : int { return _ot.id; }
//		public function set id (val:int) : void { _ot.id = val; }
		
//		public function get triggerClass () : int { return _ot.classId; }
//		public function set triggerClass (val:int) : void { _ot.classId = val; }

		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

