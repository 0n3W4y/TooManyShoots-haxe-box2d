package;

import box2D.collision.B2ContactPoint;
import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2ContactListener;

class ContactListener extends B2ContactListener{

	public function new(){
		super();
	}

	override public function beginContact(contact:B2Contact){

		var bodyUserDataA = contact.getFixtureA().getBody().getUserData();
		var fixtureA = contact.getFixtureA();
		var bodyUserDataB = contact.getFixtureB().getBody().getUserData();
		var fixtureB = contact.getFixtureB();

		if (Std.is(bodyUserDataA, PlayerActor) && Std.is(bodyUserDataB, PegActor))
		{
			bodyUserDataA.startContact();
			bodyUserDataB.hitByPlayer();
		}
		else if (Std.is(bodyUserDataB, PlayerActor) && Std.is(bodyUserDataA, PegActor))
		{
			bodyUserDataA.hitByPlayer();
			bodyUserDataB.startContact();
		}
		else if ((Std.is(bodyUserDataA, BonusChuteActor) && fixtureA.isSensor()) && Std.is(bodyUserDataB, PlayerActor))
		{
			bodyUserDataB.hitBonusTarget();
		}
		else if ((Std.is(bodyUserDataB, BonusChuteActor) && fixtureB.isSensor()) && Std.is(bodyUserDataA, PlayerActor))
		{
			bodyUserDataA.hitBonusTarget();
		}
	}

	override public function endContact(contact:B2Contact){

		var bodyUserData = contact.getFixtureA().getBody().getUserData();

		if (Std.is(bodyUserData, PlayerActor)){
			bodyUserData.stopContact();
		}

		bodyUserData = contact.getFixtureB().getBody().getUserData();

		if (Std.is(bodyUserData, PlayerActor)){
			bodyUserData.stopContact();
		}
	}
	
}