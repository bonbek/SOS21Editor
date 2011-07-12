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
		import flash.geom.Point;
      import flash.events.KeyboardEvent;
      import mx.core.ClassFactory;
      import mx.controls.List;     
      import mx.controls.listClasses.IListItemRenderer;
      import mx.controls.listClasses.ListItemRenderer;

      public class DisabledList extends List
      {
			
			
			public function DisabledList()
			{
				super();
				this.itemRenderer = new ClassFactory(DisabledListItemRenderer);
			}

			/**
			 * @inheritDoc
			 * Prevent mouse over handler when item is disabled.
			 */
			override protected function mouseOverHandler (event:MouseEvent) : void {
				if (!itemDisable(event)) super.mouseOverHandler(event);

			}

			/**
			 * @inheritDoc
			 * Prevent mouse down handler when item is disabled.
			 */
			override protected function mouseDownHandler(event:MouseEvent):void {
				if (!itemDisable(event)) super.mouseDownHandler(event);
			}

			/**
			 * @inheritDoc
			 * Prevent mouse up handler when item is disabled.
			 */
			override protected function mouseUpHandler (event:MouseEvent) : void {
				if (!itemDisable(event)) super.mouseUpHandler(event);
			}

			/**
			 * @inheritDoc
			 * Prevent mouse click handler when item is disabled.
			 */
			override protected function mouseClickHandler(event:MouseEvent):void {
				if (!itemDisable(event)) super.mouseClickHandler(event);
			}

			/**
			 * @inheritDoc
			 * Prevent mouse double click handler when item is disabled.
			 */
			override protected function mouseDoubleClickHandler (event:MouseEvent) : void {
				if (itemDisable(event)) {
					// Disable double click.
					event.preventDefault();
				}
				else {
					super.mouseDoubleClickHandler(event);
				}
			}

			/**
			 * @inheritDoc
			 * Prevent mouse double click handler when item is disabled.
			 */
			override protected function keyDownHandler (event:KeyboardEvent) : void {
				event.stopPropagation();
				// Disable key down event.        
				//super.keyDownHandler(event);
			}                
			
			/**
			 * Flag item activé / désacitvé
			 *	@param event MouseEvent
			 *	@return Boolean
			 */
			private function itemDisable (event:MouseEvent) : Boolean
			{
				var item:IListItemRenderer = mouseEventToItemRenderer(event);
				if (!item) return false;

				if (("@enabled" in item.data) || ("enabled" in item.data)) {
					var enabled:Boolean = item.data is XML ? item.data.@enabled : item.data.enabled;
					return (!enabled || enabled == false) ? true : false;
				}
				else {
					return false;
           }
			}
			
      }
}
