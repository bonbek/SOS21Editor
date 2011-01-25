package flexmapeditor.view.components {
	
	import mx.controls.List;
	import mx.collections.ArrayCollection;
	import flexmapeditor.view.components.renderer.TriggerBrowserListItem;
	import mx.core.ClassFactory;
	import mx.controls.listClasses.IListItemRenderer;
	import flash.display.Sprite;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  17.01.2011
	 */
	public class TriggerList extends List {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function TriggerList ()
		{
			super();

			dataProvider = new ArrayCollection();
			itemRenderer = new ClassFactory(TriggerBrowserListItem);
			// pour que les l'affichage des items liste puissent se déplier
			variableRowHeight = true;
			setStyle("backgroundColor", null);
			setStyle("borderSkin", null);
			setStyle("paddingLeft", 0);
			setStyle("paddingRight", 8);
			setStyle("paddingLeft", 4);
			setStyle("selectionColor", null);
			setStyle("useRollOver", false);
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var branchColors:Array = [0xFF0000, 0x00FF00, 0x0000FF];
		private var currentBranchColor:uint = branchColors[0];
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		protected function nextBranchColor() : uint
		{
			var index:int = branchColors.indexOf(currentBranchColor);
			if (++index == branchColors.length) currentBranchColor = branchColors[0];
			else
				currentBranchColor = branchColors[index];
			
			return currentBranchColor;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Ajoute un item à la liste
		 *	@param item Object TriggerProperties
		 *	@param recursive Boolean flag ajout recursif
		 */
		public function addItem (item:Object, recursive:Boolean = true) : void
		{
			var depth:int = 0;
			_addItem(item, depth);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Ajout item à la liste de manière recursive
		 *	@param item Object TriggerProperties
		 *	@param depth int
		 * 
		 * objet item descripteur
		 * tree:Boolean trigger racine, plusieurs autres triggers chainés
		 * branch:Boolean trigger racine, cascade de trigger chaînés
		 * link: lie un autre trigger (à un triggger onComplete)
		 * depth:profondeur dans l'arborescence
		 */
		private function _addItem (item:Object, depth:int) : Object
		{
			// Objet item de liste
			var o:Object = {triggerProperties:item, depth:depth, tree:false, branch:false, linked:false};

			var chained:Array = item.chainedTriggers;
			if (chained)
			{
				var t:Object;
				// on est sur un arbre
				if (chained.length > 1)
				{
					// on ajoute tous les items de l'arbre plus celui-ci
					o.tree = true;
					var treeColor:uint = o.treeColor = nextBranchColor();
					dataProvider.addItem(o);
					for each (t in chained) {
						_addItem(t, depth + 1).branchColor = treeColor;
					}
				}
				else if (chained.length == 1) {
					// l'item à un seul trigger onComplete, et on va tester si c'est
					// une branch ou un item de branch
					// > il va être de type liaison
					o.link = true;
					// on prend le dernier item ajouté au dataProvider
					if (dataProvider.length > 0) {
						var po:Object = dataProvider.getItemAt(dataProvider.length - 1);
						// l'item d'avant est un arbre, donc celui-ci est denc une branche
						if (po.tree) {
							o.branch = true;
						}
						// l'item d'avant n'est pas un arbre
						else {
							var chainedTo:Array = item.chainedTo;
							if (chainedTo)
							{
								// l'item précédent n'est pas lié à celui-ci, celui-ci
								// est donc une branche
								if (chainedTo.indexOf(po.item) == -1)
									o.branch = true;
							}
						}
					}
					// on ajoute l'item
					dataProvider.addItem(o);					
					// on ajoute le prochain
					_addItem(chained[0], depth);	
				}
			}
			else {
				dataProvider.addItem(o)
			}
			
			return o;
		}
		
		/*override protected function drawSelectionIndicator(indicator:Sprite, x:Number,
	       y:Number, width:Number, height:Number, color:uint,
	       itemRenderer:IListItemRenderer):void
	   {
	      return;
	   }*/
		
	}

}