package
{
	import org.flixel.*;
	public class Credit extends FlxSprite
	{
		[Embed(source="../assets/credit_sprite.png")] private static var imgCredits:Class;
		
		
		public function Credit(X:Number, Y:Number):void
		{
			super(X, Y, imgCredits);
			loadGraphic(imgCredits, true, true, 31, 31);
			addAnimation("def", new Array(0,1,2,3,4,5,6,7,8,9), 5, true);
			//offset = new FlxPoint(2, 2);
			//width = 31;
			//height = 31
			play("def");
		}
		
		
		
		override public function update():void
		{
			
		}
	}
}
