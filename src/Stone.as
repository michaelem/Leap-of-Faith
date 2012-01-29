package
{
	import org.flixel.*;
	public class Stone extends FlxSprite
	{
		[Embed(source="../assets/tiles_cardboard.png")] private static var imgStones:Class;
		[Embed(source="../assets/stone_emitter.png")] private static var imgParticles:Class;
		
		
		public var isHit:Boolean;
		private var particles:FlxEmitter;
		private var particlesTimer:FlxTimer;
		
		public function Stone(X:Number, Y:Number):void
		{
			super(X, Y, imgStones);
			maxVelocity.x = 180;
			maxVelocity.y = 400;
			acceleration.y = 700;
			drag.x = maxVelocity.x * 4;
			loadGraphic(imgStones, true, true, 35, 35);
			addAnimation("fall", new Array(6,6,6), 3, true);
			
			particles = new FlxEmitter();
			particles.makeParticles(imgParticles, 16, 16, true, 0);
			particles.setRotation(0, 360);
			particles.setYSpeed(-100, 100);
			particles.setXSpeed(-100, 100);
			particles.gravity = 200;
			
			particlesTimer = new FlxTimer();
			isHit = false;
			//offset = new FlxPoint(2, 2);
			//width = 31;
			//height = 31
		}
		
		public function hit():void
		{
			if (!isHit) {
				isHit = true;
				particles.start();
				solid = false;
			}
			//particlesTimer.start(2, 1, function():void{exists = false});
		}
		
		override public function update():void
		{
			acceleration.x = 0;
			play("fall");
			if (!isHit) {
				particles.at(this);
			}
			particles.update();
		}
		
		override public function draw():void
		{
			if (!isHit) {
				super.draw();
			}
			particles.setCameras(this.cameras);
			particles.draw();
		}
	}
}
