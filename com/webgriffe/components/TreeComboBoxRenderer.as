package com.webgriffe.components
{
import mx.controls.Tree;
import mx.events.ListEvent;

public class TreeComboBoxRenderer extends Tree
{
	// -------------------------------------------------------------------------
	//
	// Properties 
	//			
	// -------------------------------------------------------------------------

	[Bindable]
	public var outerDocument:TreeComboBox;
	
	// -------------------------------------------------------------------------
	//
	// Constructor 
	//			
	// -------------------------------------------------------------------------
	
	public function TreeComboBoxRenderer()
	{
		super();
		this.addEventListener(ListEvent.CHANGE, onSelectionChanged);
	}

	// -------------------------------------------------------------------------
	//
	// Handlers 
	//			
	// -------------------------------------------------------------------------
	
	private function onSelectionChanged (event:ListEvent) : void
	{
		outerDocument.updateLabel(event.currentTarget.selectedItem);
	}

	// -------------------------------------------------------------------------
	//
	// Other methods 
	//			
	// -------------------------------------------------------------------------
	
	override public function getParentItem (node:Object) : *
	{
		if (node is XML) return getParentItem (node);
		
		trace("getParentItem");
		for each (var o:Object in dataProvider) {
			trace(o);
		}
		
		/*var oparent:Object;
		var achildren:Array;
		if (dataProvider is Array || dataProvider is ArrayCollection) {
			oparent = dataProvider;
			achildren = dataProvider;
		}
		else {
			if ("childen" in dataProvider) achildren = dataProvider.children;
		}
		
		if (!achildren) return null;
		
		while (achildren)
		{
			if (achildren.indexOf(node) > -1) {
				achildren = null;
			}
			else {
				
			}
		}*/
		
		return null;
	}
	
	public function expandParents (node:Object) : void
	{
		if (node && !isItemOpen(node))
		{
			expandItem(node, true);
			expandParents(getParentItem(node));
      }	
	}
	
	public function selectNode (node:Object) : void
	{
		selectedItem = node;
		var idx:int = getItemIndex(selectedItem);
    	scrollToIndex(idx);
	}
}
}