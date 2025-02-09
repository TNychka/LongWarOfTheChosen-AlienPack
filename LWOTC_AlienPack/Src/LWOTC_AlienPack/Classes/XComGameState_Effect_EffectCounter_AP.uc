//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_EffectCounter.uc
//  AUTHOR:  John Lumpkin / Amineri (Long War Studios)
//  PURPOSE: This is a component extension for Effect GameStates, counting the number of
//		times an effect is triggered. Can be used to restrict passive abilities to once
//		per turn.
//---------------------------------------------------------------------------------------

class XComGameState_Effect_EffectCounter_AP extends XComGameState_BaseObject;

var int uses;

function XComGameState_Effect_EffectCounter_AP InitComponent()
{
	uses = 0;
	return self;
}

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

simulated function EventListenerReturn ResetUses(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState								NewGameState;
	local XComGameState_Effect_EffectCounter_AP		ThisEffect;

	if(uses != 0)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update: Reset Effect Counter");
		ThisEffect=XComGameState_Effect_EffectCounter_AP(NewGameState.CreateStateObject(Class,ObjectID));
		ThisEffect.uses = 0;
		NewGameState.AddStateObject(ThisEffect);
		`TACTICALRULES.SubmitGameState(NewGameState);
	}
	return ELR_NoInterrupt;
}

simulated function EventListenerReturn IncrementUses(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState								NewGameState;
	local XComGameState_Effect_EffectCounter_AP		ThisEffect;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update: Increment Effect Counter");
	ThisEffect=XComGameState_Effect_EffectCounter_AP(NewGameState.CreateStateObject(Class,ObjectID));
	ThisEffect.uses += 1;
	//`LOG (EventID $ ": Incremented to" @ string (Thiseffect.uses));
	NewGameState.AddStateObject(ThisEffect);
	`TACTICALRULES.SubmitGameState(NewGameState);
	return ELR_NoInterrupt;
}

defaultproperties
{
	bTacticalTransient=true
}
