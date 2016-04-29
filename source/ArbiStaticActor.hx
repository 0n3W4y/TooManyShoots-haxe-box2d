package;

import flash.geom.Point;
import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import flash.display.Sprite;


class ArbiStaticActor extends Actor{

	public function new(location:Point, arrayOfCoordinates:Array<Dynamic>){
	    
		var myBody:B2Body = createBodyFromCoordinates(arrayOfCoordinates, location);
		var mySprite:Sprite = createSpriteFromCoordinates(arrayOfCoordinates, location);
		
		super(myBody, mySprite);
	}

	private function createBodyFromCoordinates(arrayOfCoordinates:Array<Dynamic>, location:Point){

		var world = Global.world;
		var world_scale = Global.world_scale;
		var world_sprite = Global.world_sprite;

		var newShapeDef:B2PolygonShape = new B2PolygonShape();
		newShapeDef.setAsArray(arrayOfCoordinates, arrayOfCoordinates.length);
		var fixtureDefinition = new B2FixtureDef();
		fixtureDefinition.shape = newShapeDef;
		fixtureDefinition.density = 0;
		fixtureDefinition.friction = 0.2;
		fixtureDefinition.restitution = 0.3;
		var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set (location.x/world_scale, location.y/world_scale);
		var body = world.createBody(bodyDefinition);
		body.createFixture (fixtureDefinition);
		return body;
	}

	private function createSpriteFromCoordinates(arrayOfCoordinates:Array<Dynamic>, location:Point){
		
		var world = Global.world;
		var world_scale = Global.world_scale;
		var world_sprite = Global.world_sprite;

		var newSprite = new Sprite();
		newSprite.graphics.lineStyle(2, 0x0000bb);
		var firstPoint = arrayOfCoordinates[0];
		newSprite.graphics.moveTo(firstPoint.x*world_scale, firstPoint.y*world_scale);
		newSprite.graphics.beginFill(0x0000bb, 1);
		for (i in 1...arrayOfCoordinates.length){
			var newPoint = arrayOfCoordinates[i];
			newSprite.graphics.lineTo(newPoint.x*world_scale, newPoint.y*world_scale);
		}
		newSprite.graphics.lineTo(firstPoint.x*world_scale, firstPoint.y*world_scale);
		newSprite.graphics.endFill();

		newSprite.x = location.x;
		newSprite.y = location.y;
		world_sprite.addChild(newSprite);

		return newSprite;

	}
}