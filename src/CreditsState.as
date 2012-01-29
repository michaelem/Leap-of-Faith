package
{
	import org.flixel.*;
	
	public class CreditsState extends FlxState
	{
		[Embed(source="../assets/aaaiight.ttf", fontFamily="aaaiight", embedAsCFF="false")] private	var	aaaiightFont:String;
		[Embed(source="../assets/border.png")] private static var ImgBorder:Class;
		
		private var sertscho:FlxText;
		private var sertschoHandle:FlxText;
		
		private var simon:FlxText;
		private var simonHandle:FlxText;
		
		private var play:FlxText;
		
		
		override public function create():void
		{
			sertscho = new FlxText(0, 70, FlxG.width, "Martin Sereinig");
			sertscho.setFormat("aaaiight", 25, 0xFFFFFFFF, "center");
			add(sertscho);
			
			sertschoHandle = new FlxText(0, 100, FlxG.width, "@srecnig");
			sertschoHandle.setFormat("aaaiight", 15, 0xFFFFFFFF, "center");
			add(sertschoHandle);
			
			sertscho = new FlxText(0, 130, FlxG.width, "Simon Parzer");
			sertscho.setFormat("aaaiight", 25, 0xFFFFFFFF, "center");
			add(sertscho);
			
			sertschoHandle = new FlxText(0, 160, FlxG.width, "@simonparzer");
			sertschoHandle.setFormat("aaaiight", 15, 0xFFFFFFFF, "center");
			add(sertschoHandle);
			
			sertscho = new FlxText(0, 130, FlxG.width, "Simon Parzer");
			sertscho.setFormat("aaaiight", 25, 0xFFFFFFFF, "center");
			add(sertscho);
			
			sertschoHandle = new FlxText(0, 160, FlxG.width, "@simonparzer");
			sertschoHandle.setFormat("aaaiight", 15, 0xFFFFFFFF, "center");
			add(sertschoHandle);
			
			
			
			
			
			var border:FlxSprite = new FlxSprite(0, 0, ImgBorder);
			add(border);
			
			
			
		} // end function create
		
		
		override public function update():void
		{
			super.update(); // calls update on everything you added to the game loop
			
			if (FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE")) {
				FlxG.switchState(new MenuState());
			}
		} // end function update
		
		
		public function CreditsState()
		{
			super();
			
		}  // end function MenuState
		
	} // end class
}