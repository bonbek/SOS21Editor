package flexmapeditor.view.components.renderer {

	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.containers.Box;
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.Spacer;
	import flash.display.DisplayObject;
	import flash.text.TextLineMetrics;
	import mx.controls.Text;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import mx.controls.Image;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  13.01.2011
	 */
	public class TriggerBrowserListItem extends Canvas {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static var addForms:Array;
		
		// icon fold bouton description
		[Embed(source="../icons/fold_icon.png")]
		private var descriptionFoldIcon:Class;
		// icon unfold bouton description
		[Embed(source="../icons/unfold_icon.png")]
		private var descriptionUnFoldIcon:Class;

		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TriggerBrowserListItem (data:Object = null)
		{
			super();
			if (data) this.data = data;
		}
		
		//---------------------------------------
		// PROTECTED VARIABLES
		//---------------------------------------
		
		// Composants
		// > Label identifiant trigger (en haut droite)
		private var id_mc:Label;
		// > Text résumé (conditions, intitulé action, court résumé)
		private var summary_mc:Label;
		// > Text descriptif complet
		private var description_mc:Text;
		// > Bouton déplier / replier descriptif
		protected var foldDescription_btn:Image;
		
		// Data descriptives trigger (voir forms[].createDescriptor())
		protected var _descriptor:Object;
		// Liste des triggers enfants chainés directement ou indirectement
		// à celui-ci
		protected var childrenTrigger:Array = [];
		
		// Sizing et autre
		protected var childrenMargin:int = 20;
		// hauteur composant réplié (sans desciptif, ni enfant)
		protected var baseHeight:int = 30;
		// espacement départ affichage enfants
		protected var childrenTop:int = 6;
		// espacement enfants
		protected var childrenGap:int = 4;
		
		// Etats / type
		protected var _isLinked:Boolean;
		
		// WIP
		public var isBranch:Boolean;
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 * TODO Documenter
		 */
		private var bDataChanged:Boolean;
		override public function set data (val:Object) : void
		{
			bDataChanged = true;
			var chained:Array = val.chainedTriggers;
			if (chained) {
				if (chained.length > 1) _isTree = true;
				else if (chained.length == 1)
					_isLinked = true;
					
			}
	
			super.data = val;
		}
		

//		protected var _isRootNode:Boolean;
//		public function get isRootNode () : Boolean
//		{ return _isRootNode; }
		protected var _isTree:Boolean;
		public function get isTree () : Boolean
		{ return _isTree; }
		
		private var bFoldedChange:Boolean;
		protected var _folded:Boolean = false;
		public function get folded () : Boolean
		{ return _folded; }
		
		public function fold () : void
		{
			if (_folded) return;
			
			bFoldedChange = true;
			
			_folded = true;
			invalidateProperties();
		}
		
		public function unFold () : void
		{
			if (!_folded) return;
			
			bFoldedChange = true;
			_folded = false;
			invalidateProperties();
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Crée un bloc "descriptif" trigger
		 */
		public static function create (trigger:Object, recursive:Boolean = true) : TriggerBrowserListItem
		{
			var li:TriggerBrowserListItem = new TriggerBrowserListItem();
			li.data = trigger;

			return li;
		}
		
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
		
		protected function onClick (event:MouseEvent) : void
		{
			if (_folded) unFold();
			else
				fold();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 * Implémentation method commitProperties()
		 */
      override protected function commitProperties ():void
		{
			super.commitProperties();
			
			if (bDataChanged)
			{
				bDataChanged = false;
				
				_descriptor = addForms[data.triggerClassId].createDescriptor(data);
				
				// Intitulé condition
				if (data.cond) condLabel_mc.text = data.cond;
				// Identifiant
				id_mc.text = data.id;
				// Intitulé
				var txt:String = "<b>" + _descriptor.title + "</b>";
				if ("summary" in _descriptor)
					txt += " " + _descriptor.summary;
				
				if (_folded)
				{
					if ("description" in _descriptor)
						txt += "<br>" + _descriptor.description;					
				}

				summary_mc.htmlText = txt;
					
				// on suppose que l'on est sur un noeud racine
			//	if (!(parent is TriggerBrowserListItem))				
			//		_isRootNode = true;
				var chained:Array = data.chainedTriggers;
				
				if (_isTree)
				{
					trace("isTree", data.id);
					if (chained)
					{
						var ntbli:TriggerBrowserListItem;
						var cchained:Array;
						for each (var trigger:Object in chained)
						{
							ntbli = new TriggerBrowserListItem();
							ntbli.data = trigger;
							childrenTrigger.push(ntbli);
						}
					}
				}
				else
				{
					if (parent is TriggerBrowserListItem)
					{
						if (TriggerBrowserListItem(parent).isTree)
						{
							isBranch = true;
							trace("isBranch", data.id);
							chained = data.chainedTriggers;
							if (chained)
							{
								while (true)
								{
									if (chained.length > 1) {
										break;
									}
									else {
										ntbli = new TriggerBrowserListItem();
										ntbli.data = chained[0];
										childrenTrigger.push(ntbli);
										chained = chained[0].chainedTriggers;
										if (!chained) break;
									}
								}
							}
						}
					}
				}
				
				/*if (_isTree)
				{
					if (chained)
					{
						var ntbli:TriggerBrowserListItem;
						var cchained:Array;
						for each (var trigger:Object in chained)
						{
							ntbli = new TriggerBrowserListItem();
							ntbli.data = trigger;
							childrenTrigger.push(ntbli);
							cchained = trigger.chainedTriggers;
							if (cchained)
							{
								while (true)
								{
									if (cchained.length > 1) {
										break;
									}
									else {
										ntbli = new TriggerBrowserListItem();
										ntbli.data = cchained[0];
										childrenTrigger.push(ntbli);
										cchained = cchained[0].chainedTriggers;
										if (!cchained) break;
									}
								}
							}
						}
					}
				}*/

				for each (var child:TriggerBrowserListItem in childrenTrigger)
				{
					if (!contains(child))
					{
						addChild(child);
					}
				}
								
				invalidateDisplayList();				
			}
			
			// Pliage / dépliage info
			if (bFoldedChange)
			{
				bFoldedChange = false;
				
				// Intitulé
				txt = "<b>" + _descriptor.title + "</b>";
				if ("summary" in _descriptor)
					txt += " " + _descriptor.summary;
				
				summary_mc.htmlText = txt;
				
				if (_folded)
				{
					// Changement d'icone
					foldDescription_btn.source = descriptionUnFoldIcon;
					if ("description" in _descriptor)
					{
						description_mc.htmlText = _descriptor.description;
						if (!contains(description_mc)) addChild(description_mc);
					}
				}
				else
				{
					foldDescription_btn.source = descriptionFoldIcon;
					if (contains(description_mc)) removeChild(description_mc);
				}
				
				
				invalidateDisplayList();
			}
			
      }
		
		/**
		 * @inheritDoc
		 */
		override protected function measure ():void
		{
			super.measure();

			// La hauteur calculée en fonction des états enfants pliés / dépliés
			// et le descritif plié / déplié
			
			// Hauteur de base, hauteurs label condition + label sommaire
			var h:Number = baseHeight + (_folded ? description_mc.measuredHeight : 0);
			
			if (_isTree || isBranch)
			{
				h += childrenTop;
				for each (var child:TriggerBrowserListItem in childrenTrigger)
					h += child.getExplicitOrMeasuredHeight();
			}

			measuredHeight = measuredMinHeight = h;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			// marge gauche
			var paddingLeft:int = 10;
			// marge droite
			var paddingRight:int = 4;
			// largeur utilisable
			var usableWidth:int = unscaledWidth - paddingLeft - paddingRight;
			// largeur label identifiant
			var id_mcWidth:int = id_mc.getExplicitOrMeasuredWidth();
			// largeur des textes condition, résumé et descriptif
			var textsWidth:int = usableWidth - id_mcWidth;

			// placement / taille label conditions
			condLabel_mc.setActualSize(textsWidth, 20);
			condLabel_mc.move(paddingLeft, 0);
			// placement / taille label identifiant
			id_mc.move(textsWidth + paddingLeft, 0);
			// placement / taille label résumé
			summary_mc.move(paddingLeft, 12);
			summary_mc.width = textsWidth;
			// placement bouton plie/déplie descriptif
			foldDescription_btn.move(textsWidth + paddingLeft, 20);
			// pacement / taille text description
			if (contains(description_mc))
			{
				description_mc.width = textsWidth;
				description_mc.move(paddingLeft, 30);
			}
			
			// hauteur base + descriptif
			var h:Number = baseHeight + (_folded ? description_mc.measuredHeight : 0);	
			
			// Placement triggers enfants
			// offset de départ
			var offs:int = h + childrenTop;
			if (_isTree)
			{
				for each (var child:TriggerBrowserListItem in childrenTrigger) {
					child.move(childrenMargin, offs);
					offs += child.getExplicitOrMeasuredHeight() + childrenGap;
				}
			}
			else if (isBranch)
			{
				for each (child in childrenTrigger) {
					child.move(0, offs);
					offs += child.getExplicitOrMeasuredHeight() + childrenGap;
				}				
			}
			
			// Affichage background
			graphics.clear();
			graphics.lineStyle(1, 0x666666);
			graphics.beginFill(0xE5E5E5);
			graphics.drawRoundRect(0, 0, unscaledWidth, h, 6, 6);
			graphics.endFill();
			// affichage lien vers trigger suivant
			if (_isLinked)
			{
				graphics.lineStyle(NaN);
				graphics.beginFill(0xE5E5E5);
				graphics.drawCircle(unscaledWidth / 2, h, childrenGap);
				graphics.endFill();
			}
			
		}
		
		private var condLabel_mc:Label;
		override protected function createChildren () : void
		{
			super.createChildren();
			
			percentWidth = 100;
			percentHeight = 100;
			horizontalScrollPolicy = "off";
			clipContent = false;
			
			// Conteneur des triggers chainés
			/*if (!childrenContainer_mc)
			{
				childrenContainer_mc = new Box();
				childrenContainer_mc.percentWidth = 100;
//				childrenContainer_mc.setStyle("horizontalAlign", "right");
				addChild(childrenContainer_mc);
			}*/
			
			// Intitulé condition
			if (!condLabel_mc)
			{
//				var cont:Box = new Box();
//				cont.direction = "horizontal";
//				cont.percentWidth = 100;
				condLabel_mc = new Label();
				condLabel_mc.percentWidth = 100;
				condLabel_mc.truncateToFit = true;
				condLabel_mc.setStyle("fontSize", 9);
				condLabel_mc.setStyle("paddingLeft", 0);
				condLabel_mc.setStyle("paddingRight", 0);
				condLabel_mc.setStyle("paddingTop", 0);
				condLabel_mc.setStyle("paddingBottom", 0);
				
//				condLabel_mc.setStyle("fontStyle", "italic");
				addChild(condLabel_mc);

				id_mc = new Label();
				id_mc.width = 30;
				id_mc.setStyle("textDecoration", "underline");
				id_mc.setStyle("textAlign", "right");
				id_mc.setStyle("paddingLeft", 0);
				id_mc.setStyle("paddingRight", 0);
				id_mc.setStyle("paddingTop", 0);
				id_mc.setStyle("paddingBottom", 0);
				addChild(id_mc);
//				id_mc.text = "id";
//				addChild(cont);
			}

			// Intitulé
			if (!summary_mc)
			{
				summary_mc = new Label();
				summary_mc.truncateToFit = true;
				summary_mc.setStyle("paddingLeft", 0);
				summary_mc.setStyle("paddingRight", 0);
				summary_mc.setStyle("paddingTop", 0);
				summary_mc.setStyle("paddingBottom", 0);
				addChild(summary_mc);
			}
			
			// Text info
			if (!description_mc)
			{
				description_mc = new Text();
//				info_mc.percentWidth = 100;
//				addChild(info_mc);
			}
			
			foldDescription_btn = new Image();
			foldDescription_btn.source = descriptionFoldIcon;
			addChild(foldDescription_btn);
			
			foldDescription_btn.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		/*public var testLabel:Label;
		public function build () : void
		{
			setStyle("horizontalGap", 0);
			setStyle("verticalGap", 0);
			
			testLabel = new Label();
			addChild(testLabel);
		}*/
	
	}

}