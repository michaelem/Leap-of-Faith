package
{
	import org.flixel.*;
	
	public class MenuState extends FlxState
	{
		[Embed(source="../assets/aaaiight.ttf", fontFamily="aaaiight", embedAsCFF="false")] private	var	aaaiightFont:String;
		[Embed(source="../assets/border.png")] private static var ImgBorder:Class;
		
		private var credits:FlxText;
		private var title:FlxText;
		private var play:FlxText;
		
		
		override public function create():void
		{
			title = new FlxText(0, 80, FlxG.width, "Leap of Faith");
			title.setFormat("aaaiight", 35, 0xFFFFFFFF, "center");
			add(title);
			
			play = new FlxText(0, 220, FlxG.width, "play");
			play.setFormat("aaaiight", 25, 0xFFFFFFFF, "center");
			play.flicker(-1);
			add(play);
			
			credits = new FlxText(0, 260, FlxG.width, "credits");
			credits.setFormat("aaaiight", 25, 0xFFFFFFFF, "center");
			add(credits);
			
			
			
			
			var border:FlxSprite = new FlxSprite(0, 0, ImgBorder);
			add(border);
			
			
			
		} // end function create
		
		
		override public function update():void
		{
			super.update(); // calls update on everything you added to the game loop
			
			if (FlxG.keys.justPressed("UP") || (FlxG.keys.justPressed("DOWN")) ) 
			{
				if (play.flickering) {
					play.flicker(0);
					credits.flicker(-1);
				}
				else {
					play.flicker(-1);
					credits.flicker(0);
				}
			}
			if (FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE")) {
				if (play.flickering) {
					FlxG.switchState(new IngameState());
				} else if (credits.flickering) {
					FlxG.switchState(new CreditsState());
				}
			}
		} // end function update
		
		
		public function MenuState()
		{
			super();
			
		}  // end function MenuState
		
	} // end class
}