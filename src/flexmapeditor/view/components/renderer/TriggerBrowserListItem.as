package flexmapeditor.view.components.renderer {

	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.controls.listClasses.IListItemRenderer;
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
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  13.01.2011
	 */
	public class TriggerBrowserListItem extends Canvas implements IListItemRenderer {
	
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
		
		//---------------------------------------
		// PROTECTED VARIABLES
		//---------------------------------------
		
		// Composants
		// > Label conditions
		private var condLabel_mc:Label;
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
		
		// Sizing et autre
		// marge gauche
		protected var paddingLeft:int = 10;
		// marge droite
		protected var paddingRight:int = 4;
		protected var _depthMargin:int = 20;
		// hauteur composant réplié (sans desciptif, ni enfant)
		protected var baseHeight:int = 30;
		// espacement départ affichage enfants
		protected var childrenTop:int = 2;
		// espacement enfants
		protected var childrenGap:int = 4;
		
		// Flag chagments
		// > changement pliage / dépliage
		private var bFoldedChange:Boolean;
		// Flasg changement de data
		private var bDataChanged:Boolean;
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 * TODO Documenter
		 */
		override public function set data (val:Object) : void
		{
			if (val == data)
			{
//				if ()
			}
			// nouvel objet data
			else
			{
				bDataChanged = true;
				super.data = val;				
			}
		}
		
		/**
		 * Flag est une racine, utilisé pour l'affichage
		 */
		public function get isTree () : Boolean {
			if (data) return data.tree;
			return false;
		}
		
		/**
		 * Flag est un branche, utilisé pour l'affichage
		 */
		public function get isBranch () : Boolean {
			if (data) return data.branch;
			return false;
		}
		
		/**
		 * Flag est un lien, utilisé pour l'affichage
		 */
		public function get isLink () : Boolean {
			if (data) return data.link;
			return false;
		}		

		/**
		 * Profondeur, utilisé pour l'affichage
		 */
		public function get depth () : int {
			if (data) return data.depth;
			return 0;
		}
		
		/**
		 * Marge de profondeur
		 */
		public function get depthMargin () : int
		{ return depth * _depthMargin; }
		
		/**
		 * Flag état déplié
		 */
		public function get folded () : Boolean
		{
			if (data) return data.folded;

			return false;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 *	Déplier */
		public function fold () : void
		{
			trace(data.triggerProperties, "fold()");
			if (folded) return;
			
			bFoldedChange = true;
			// on stock l'état dans les data car les
			// items list sont réutilisés
			data.folded = true;
			invalidateProperties();
		}
		
		/**
		 *	Replier */
		public function unFold () : void
		{
			trace(data.triggerProperties, "unfold()");
			if (!folded) return;
			
			bFoldedChange = true;
			// on stock l'état dans les data car les
			// items list sont réutilisés
			data.folded = false;
			invalidateProperties();
		}
		
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
		
		/**
		 * Réception events des composants
		 *	@param event Event
		 */
		protected function handleEvent (event:Event) : void
		{
			switch (true)
			{
				// > click sur bouton fold
				case event.target == foldDescription_btn || event.type == MouseEvent.DOUBLE_CLICK :
					if (folded) unFold();
					else
						fold();
					break;
				default :
					break;
			}
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
			
			if (!data) return;
			
			// Changement des data
			if (bDataChanged)
			{
				bDataChanged = false;
				
				_descriptor = addForms[data.triggerProperties.triggerClassId].createDescriptor(data.triggerProperties);

				// Intitulé condition
				if (data.triggerProperties.cond)
					condLabel_mc.text = data.triggerProperties.cond;
				// Identifiant
				id_mc.text = data.triggerProperties.id;
				// Intitulé
				var txt:String = "<b>" + _descriptor.title + "</b>";
				if ("summary" in _descriptor)
					txt += " " + _descriptor.summary;

				summary_mc.htmlText = txt;
				
				// Mise à jour état
				updateFolding();
				invalidateDisplayList();
			}
			
			// Changement pliage / dépliage descriptif
			if (bFoldedChange)
			{
				bFoldedChange = false;
				updateFolding();
				invalidateDisplayList();
			}
			
      }
		
		/**
		 * @inheritDoc
		 * Implémentation method measure()
		 */
		override protected function measure ():void
		{
			super.measure();

			// La hauteur calculée en fonction de l'état descritif plié / déplié			
			// Hauteur de base, hauteurs label condition + label sommaire
			var h:Number = baseHeight + (folded ? description_mc.measuredHeight : 0) + childrenGap;
			
			if (isTree) h += childrenTop;
			
			measuredHeight = measuredMinHeight = h;
		}
		
		/**
		 * @inheritDoc
		 * Implémentation method updateDisplayList()
		 */
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// Pas de data, on affiche pas
			if (!data) return;

			// largeur utilisable
			var usableWidth:int = unscaledWidth - paddingLeft - paddingRight;
			// largeur label identifiant
			var id_mcWidth:int = id_mc.getExplicitOrMeasuredWidth();
			// largeur des textes condition, résumé et descriptif
			var textsWidth:int = usableWidth - id_mcWidth - depthMargin;
			var textsX:int = paddingLeft + depthMargin;
			var rightX:int = textsWidth + paddingLeft + depthMargin;
			
			// placement / taille label conditions
			condLabel_mc.setActualSize(textsWidth, 20);
			condLabel_mc.move(textsX, 0);
			// placement / taille label identifiant
			id_mc.move(rightX, 0);
			// placement / taille label résumé
			summary_mc.move(textsX, 12);
			summary_mc.width = textsWidth;
			// placement bouton plie/déplie descriptif
			foldDescription_btn.move(unscaledWidth - paddingRight - foldDescription_btn.width, 16);
			// pacement / taille text description
			if (contains(description_mc))
			{
				description_mc.width = textsWidth;
				description_mc.move(textsX, 30);
			}
			
			// hauteur base + descriptif
			var h:Number = measuredHeight - childrenGap;
			if (isTree) h -= childrenTop;
			
			// Affichage background
			var margin:int = depthMargin;
			graphics.clear();
//			graphics.lineStyle(1, 0x666666);
			graphics.beginFill(0xf2f2f2);
			graphics.drawRoundRect(margin, 0, unscaledWidth - margin, h, 10, 10);
			graphics.endFill();
			
			// affichage pastille
			if (data.treeColor)
			{
				graphics.lineStyle(NaN);
				graphics.beginFill(data.treeColor);
				graphics.drawCircle(margin + _depthMargin + 6, h, 2);
				graphics.endFill();				
			}
			
			// affichage pastille
			if (data.branchColor)
			{
				graphics.lineStyle(NaN);
				graphics.beginFill(data.branchColor);
				graphics.drawCircle(margin + 6, 4, 2);
				graphics.endFill();				
			}
			
			// affichage lien vers trigger suivant
			if (isLink)
			{
				graphics.lineStyle(NaN);
				graphics.beginFill(0xf2f2f2);
				graphics.drawCircle(unscaledWidth / 2, h, childrenGap);
				graphics.endFill();
			}
			
		}
		
		public static var fx:GlowFilter = new GlowFilter(0x00000, .5);
		
		/**
		 * @inheritDoc
		 * Implémentation method createChildren()
		 */
		override protected function createChildren () : void
		{
			super.createChildren();
			
			filters = [fx];
			
			// Options
			percentWidth = 100;
			percentHeight = 100;
			horizontalScrollPolicy = "off";
//			clipContent = false;
			
			// Intitulé condition
			if (!condLabel_mc)
			{
				condLabel_mc = new Label();
				condLabel_mc.percentWidth = 100;
				condLabel_mc.truncateToFit = true;
				condLabel_mc.setStyle("fontSize", 9);
				condLabel_mc.setStyle("paddingLeft", 0);
				condLabel_mc.setStyle("paddingRight", 0);
				condLabel_mc.setStyle("paddingTop", 0);
				condLabel_mc.setStyle("paddingBottom", 0);
				addChild(condLabel_mc);
			}
			
			// Identifiant action
			if (!id_mc)
			{
				id_mc = new Label();
				id_mc.width = 30;
				id_mc.setStyle("textDecoration", "underline");
				id_mc.setStyle("textAlign", "right");
				id_mc.setStyle("paddingLeft", 0);
				id_mc.setStyle("paddingRight", 0);
				id_mc.setStyle("paddingTop", 0);
				id_mc.setStyle("paddingBottom", 0);
				addChild(id_mc);
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
			if (!description_mc) {
				description_mc = new Text();
			}
			
			// Bouton pliage / dépliage descriptif
			if (!foldDescription_btn)
			{
				foldDescription_btn = new Image();
				foldDescription_btn.source = descriptionFoldIcon;
				foldDescription_btn.buttonMode = true;
				addChild(foldDescription_btn);		
			}
			
			// Ecoutes click bouton fold, id trigger et liens dans champ descriptif
			foldDescription_btn.addEventListener(MouseEvent.CLICK, handleEvent, false, 0, true);
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, handleEvent, false, 0, true);
		}
		
		/**
		 *	@private
		 * Rafraichissement état plié / déplié
		 */
		protected function updateFolding () : void
		{
			if (folded)
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
				description_mc.htmlText = "";
				if (contains(description_mc)) removeChild(description_mc);
			}
			
		}
	
	}

}