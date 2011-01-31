package flexmapeditor.view.components
{
	
	
/**
 * DisabledListItemRenderer.as
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
      import mx.controls.Label;

      public class DisabledListItemRenderer extends Label
      {          
            private var _enabled:Boolean = true;

            /**
             *  Constructor.
             */
            public function DisabledListItemRenderer()
            {
                  super();
            }    

			

            /**
             *  @private
             */
            /*override public function set data (value:Object) : void
            {
					if (!value) return;

					if ("@enabled" in value || "enabled" in value) {
						this._enabled = value is XML ? value.@enabled : value.enabled;
					}
					else {
						this._enabled = true;
					}

					super.data = value;
            }    

            override protected function updateDisplayList (	unscaledWidth:Number,
																				unscaledHeight:Number) : void
            {
                  super.updateDisplayList(unscaledWidth, unscaledHeight);
                  if (!this._enabled) textField.setColor(getStyle("disabledColor"));
                  else
							textField.setColor(getStyle("color"));
            } */                                 
      }
}

