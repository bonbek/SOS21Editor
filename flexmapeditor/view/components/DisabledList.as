package flexmapeditor.view.components
{
	/**
	 * DisabledListr.as
	 *
	 * Copyright (c) 2008 Weimin Cai
	 * All rights reserved.
	 *
	 * The source code is the copyrighted,
	 *
	 * Revision History
	 *
	 * June 18, 2008  Weimin Cai
	 */
	      import flash.events.MouseEvent;
	      import flash.events.KeyboardEvent;
	      import mx.core.ClassFactory;
	      import mx.controls.List;     
	      import mx.controls.listClasses.IListItemRenderer;
	      import mx.controls.listClasses.ListItemRenderer;

	      public class DisabledList extends List
	      {
	            /**
	           *  Constructor.
	           */
	          public function DisabledList()
	          {
	              super();
	              this.itemRenderer = new ClassFactory(DisabledListItemRenderer);
	          }

	            /**
	             * Prevent mouse over handler when item is disabled.
	           */
	          override protected function mouseOverHandler(event:MouseEvent):void
	          {
	           var item:IListItemRenderer = mouseEventToItemRenderer(event);
	           if (itemDisable(event)) {
	                        // Disable selection.
	           } else {
	                  super.mouseOverHandler(event);
	           }
	          }

	            /**
	             * Prevent mouse down handler when item is disabled.
	           */        
	          override protected function mouseDownHandler(event:MouseEvent):void {
	           if (itemDisable(event)) {
	                        // Disable click.
	                        return;
	           } else {
	                  super.mouseDownHandler(event);
	           }              
	          }

	            /**
	             * Prevent mouse up handler when item is disabled.
	           */        
	          override protected function mouseUpHandler(event:MouseEvent):void {
	           if (itemDisable(event)) {
	                        // Disable click.
	                        return;
	           } else {
	                  super.mouseUpHandler(event);
	           }        
	          }

	            /**
	             * Prevent mouse click handler when item is disabled.
	           */        
	          override protected function mouseClickHandler(event:MouseEvent):void {
	           if (itemDisable(event)) {
	                        // Disable click.
	                        return;
	           } else {
	                  super.mouseClickHandler(event);
	           }
	          }

	            /**
	             * Prevent mouse double click handler when item is disabled.
	           */        
	          override protected function mouseDoubleClickHandler(event:MouseEvent):void {
	           if (itemDisable(event)) {
	                        // Disable double click.
	                        event.preventDefault();
	           } else {
	                  super.mouseDoubleClickHandler(event);
	           }
	          }

	          /**
	             * Prevent mouse double click handler when item is disabled.
	           */       
	           override protected function keyDownHandler(event:KeyboardEvent):void {
	           event.stopPropagation();
	           // Disable key down event.        
	           //super.keyDownHandler(event);
	           }                

	          private function itemDisable(event:MouseEvent):Boolean {
	            var item:IListItemRenderer = mouseEventToItemRenderer(event);
	           if (item != null && item.data != null
	                  && ((item.data is XML && item.data.@enabled == 'false')
	                              || item.data.enabled==false || item.data.enabled=='false')
	                  ) {
	                  return true;
	           } else {
	                  return false;
	           }
	          }    
	      }
	}
