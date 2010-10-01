package flexmapeditor.view.components
{

/**
 * DisabledComboBox.as
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
      import mx.controls.ComboBox;
      import mx.core.ClassFactory;
      import mx.events.FlexEvent;
     
      public class DisabledComboBox extends ComboBox
      {
          /**
           *  Constructor.
           */
     
          public function DisabledComboBox()
          {
              super();
              this.dropdownFactory = new ClassFactory(DisabledList);
              this.itemRenderer = new ClassFactory(DisabledListItemRenderer);
          }
         
          /**
           *  @private
           */
          override public function set dataProvider(value:Object):void
          {        
              super.dataProvider = value;
              moveToEnable();
          }
         
          private function moveToEnable():void {
            var i:int = -1; 
            for each (var obj:Object in dataProvider) {
                  i++;
                  if (this.selectedIndex == -1) {
                        this.selectedIndex = 0;
                  }
                  if (i < this.selectedIndex) {
                        continue;
                  }
                  if (obj != null
                        && ((obj is XML && obj.@enabled == 'false')
                              || obj.enabled==false || obj.enabled=='false')){                      
                        if(i == this.selectedIndex){
                              this.selectedIndex++;
                        }
                  }
            }
            if (this.selectedIndex > i) {
                  this.selectedIndex = 0;
            }
          }
         
          override public function initialize():void
          {
            this.toolTip = this.text;   
              if (initialized)
                  return;
              createChildren();
              super.initialize();
          }
     
         /**
           *  @private
           *  Make sure the drop-down width is the same as the rest of the ComboBox
           */
          override protected function updateDisplayList(unscaledWidth:Number,
                                                        unscaledHeight:Number):void
          {
              super.updateDisplayList(unscaledWidth, unscaledHeight);
              this.toolTip = this.text;
          }
           
          private function textInput_valueCommitHandler(event:FlexEvent):void
          {
              // update _text if textInput.text is changed programatically
              super.text = textInput.text;
              dispatchEvent(event);
          }
         
          private function textInput_enterHandler(event:FlexEvent):void
          {
              dispatchEvent(event);
              dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
          }    
      }
}