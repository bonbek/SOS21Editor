package flexmapeditor.view.components {
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;

	import br.com.stimuli.loading.BulkLoader;
	
	/**
	 *	Item renderer pour les aperçus de tiles dans la Librairie
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  06.09.2009
	 */
	public class TileThumbItemRenderer extends UIComponent implements IListItemRenderer {
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function TileThumbItemRenderer()
		{
			super();
			this.width = 70;
			this.height = 70;
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _data:Object;
		protected var bitmapData:BitmapData;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

//		[Bindable("dataChange")]

		public function get data():Object {
			return _data;
		}

		public function set data (value:Object) : void
		{
			if (!value) return;
			
			if (_data) {
				if (data.dataTile.assets == value.assetsUrl) return;
			}
			
			_data = value;
			draw();

			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Dessine la vignette représentant le tile
		 *	@private
		 */
		protected function draw () : void
		{	

			if (bitmapData) bitmapData.dispose();

			bitmapData = new BitmapData(60, 60, false, 0xFFFFFF);

			var loader:BulkLoader = BulkLoader.getLoader("tileAssets");			
			
			this.graphics.clear();
			
			try {
				var dob:DisplayObject;
				// CHANGED 2010-07-19 test intégration PNJ
				if (data.dataTile.pnj > 0)
				{
					var l:Object = loader.getContent(data.dataTile.assets);
					var cl:Class = l.loaderInfo.applicationDomain.getDefinition(data.dataTile.title);
					dob = new cl();
				}
				else
				{
//					dob = loader.content;
					dob = loader.getContent(data.dataTile.assets) as DisplayObject;
				}

//				var dob:DisplayObject = loader.content;
				var m:int = Math.max(dob.width, dob.height);
				// tricheur !!
				var ratio:Number = m / 60;
				if (ratio > 1)
				{
					dob.width = dob.width / ratio;
					dob.height = dob.height / ratio;
					ratio = dob.scaleX;
				}					
				var bounds:Object = dob.getBounds(dob);
				var mtx:Matrix = new Matrix();
				var tx:Number = -bounds.left;
				var ty:Number = -bounds.top;
				mtx.translate(tx, ty);
				mtx.scale(ratio, ratio);
				tx = ((70 - dob.width) / 2);
				ty = ((70 - dob.height) / 2);
				mtx.translate(tx, ty)
				bitmapData.draw(dob, mtx, null, null, null, true);
				graphics.beginBitmapFill(bitmapData, null, true, true);
	    		graphics.drawRect(5, 5, 60, 60);
      		graphics.endFill();
				dob.scaleX = dob.scaleY = 1;
			} catch (e:Error) {
					trace("!! erreur > ", data.dataTile.assets, this);
			}
		}
	
	}

}