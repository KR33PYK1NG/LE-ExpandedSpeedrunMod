Class SFXPowerScript_BioticCharge extends BioPowerScriptDesign within BioPower;

// Types
struct Charge_PendingVolume 
{
    var(Charge_PendingVolume) Volume Volume;
    var(Charge_PendingVolume) bool bTouching;
};
const TELEPORT_VISIBLE_THRESHOLD = 0.5f;
const TELEPORT_HEIGHT_THRESHOLD = 1000.f;

// Variables
var(SFXPowerScript_BioticCharge) InterpCurveFloat TimeCurve;
var(SFXPowerScript_BioticCharge) transient string FailedLineCheckName;
var(SFXPowerScript_BioticCharge) array<Charge_PendingVolume> VolumeList;
var(SFXPowerScript_BioticCharge) ScreenShakeStruct HitShake;
var(SFXPowerScript_BioticCharge) transient Vector CachedTeleportLocation;
var(SFXPowerScript_BioticCharge) transient Vector CachedTargetLocation;
var(SFXPowerScript_BioticCharge) transient Vector FailedLineCheckStart;
var(SFXPowerScript_BioticCharge) transient Vector FailedLineCheckEnd;
var(SFXPowerScript_BioticCharge) transient SFXPower_BioticCharge LocalPower;
var(SFXPowerScript_BioticCharge) transient Pawn Caster;
var(SFXPowerScript_BioticCharge) transient Pawn CachedTarget;
var(SFXPowerScript_BioticCharge) ParticleSystem PS_TeleportIn;
var(SFXPowerScript_BioticCharge) ParticleSystem PS_TeleportOut;
var(SFXPowerScript_BioticCharge) BioVFXTemplate CrustEffect;
var(SFXPowerScript_BioticCharge) SFXProjectile_Power_BioticCharge ChargeProjectile;
var(SFXPowerScript_BioticCharge) SFXCameraTransition_VanguardSlam CamTransition;
var(SFXPowerScript_BioticCharge) ForceFeedbackWaveform HitForceFeedback;
var WwiseEvent ChargeCast;
var WwiseEvent ChargeImpact;
var(SFXPowerScript_BioticCharge) float TeleportStartDelay;
var(SFXPowerScript_BioticCharge) float TeleportDelay;
var(SFXPowerScript_BioticCharge) float ImpactDelay;
var(SFXPowerScript_BioticCharge) float ImpactDelay_Min;
var(SFXPowerScript_BioticCharge) float ImpactDelay_Max;
var(SFXPowerScript_BioticCharge) float TimeStingerDelay;
var(SFXPowerScript_BioticCharge) float CounterTimeScaleValue;
var(SFXPowerScript_BioticCharge) float CameraImpactDelay;
var(SFXPowerScript_BioticCharge) bool bFailedToMoveCaster;
var(SFXPowerScript_BioticCharge) bool bCollectedVolumes;
var bool bLineCheckToHead;

// Functions
public function DebugDraw_Power(BioHUD H)
{
    H.Canvas.DrawColor = MakeColor(255, 255, 0, 255);
    H.Canvas.SetPos(15.0, 150.0);
    H.Canvas.DrawText(FailedLineCheckName);
    Outer.Owner.DrawDebugLine(FailedLineCheckStart, FailedLineCheckEnd, 0, 255, 0);
}
public function bool ShouldUsePower(Actor oCaster, Actor Target, out string sOptionalInfo)
{
    if (GetPhysicsLevel(Target, TRUE) >= 5)
    {
        sOptionalInfo = string(NotRecommended_TargetImmune);
        return FALSE;
    }
    return TRUE;
}
public function PlayFailedChargeEffects()
{
    local BioVisualEffect Effect;
    
    if (SFXGame(Outer.Owner.WorldInfo.Game).InCombat())
    {
        SFXGame(Outer.Owner.WorldInfo.Game).TriggerVocalizationEvent(89, BioPawn(Outer.Owner), BioPawn(Outer.Owner));
    }
    Effect = Class'BioVisualEffect'.static.CreateVFXOnMesh(CrustEffect, Outer.Owner, 'None', 1.0, , FALSE);
    if (Effect != None)
    {
        Effect.SetState(0, TRUE);
    }
}
public function SpawnProjectile()
{
    ChargeProjectile = Caster.Spawn(Class'SFXProjectile_Power_BioticCharge', Caster, , Caster.Location, Caster.Rotation);
    if (ChargeProjectile != None)
    {
        ChargeProjectile.CustomTimeDilation = CounterTimeScaleValue;
        ChargeProjectile.Speed = VSize(CachedTarget.Location - Caster.Location) / (ImpactDelay - TeleportDelay);
        ChargeProjectile.Init(Normal(CachedTarget.Location - Caster.Location));
    }
}
private final function TimeStinger()
{
    if (LocalPower.StingerDuration > float(0) && LocalPower.StingerSlowPct > float(0))
    {
        ApplyTemporaryGameEffect(Caster, Class'SFXGameEffect_TimeDilation', LocalPower.StingerDuration, LocalPower.StingerSlowPct, 'Shockwave', Outer.Instigator);
    }
}
public function OnRagdollPhysicsImpact(Pawn oPawn, Actor oImpactActor, Vector vImpactDir)
{
    local BioPawn oBioPawn;
    
    if (LocalPower != None)
    {
        oBioPawn = BioPawn(oPawn);
        if (oBioPawn != None)
        {
            oBioPawn.m_bRagdollEnteredPendingBodyFallSound = TRUE;
        }
        RagdollPhysicsImpact(oPawn, oImpactActor, vImpactDir, LocalPower.PhysicsImpactDamageMult);
    }
}
public function DoChargeImpact(BioPawn OwnerPawn, BioPawn HitBioPawn, optional bool bUseOwnerRotation = FALSE)
{
    local float fBioticMultiplier;
    local Vector Momentum;
    local SFXModule_GameEffectManager Manager;
    local Name BoneName;
    local array<EBioPartGroup> Parts;
    local SFXAI_Core AI;
    local SFXModule_Damage DmgModule;
    
    BoneName = 'None';
    if (GetPhysicsLevel(HitBioPawn) >= 4 || !CanBeRagdolledByPowers(HitBioPawn))
    {
        HitBioPawn.TakeDamage(LocalPower.GetDamage(), OwnerPawn.Controller, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), Class'SFXDamageType_BioticCharge');
        AI = SFXAI_Core(HitBioPawn.Controller);
        if (AI != None)
        {
            AI.FireTarget = OwnerPawn;
        }
        if (!PlayRandomReaction(HitBioPawn, Outer.Instigator, LocalPower.AnimatedReactions))
        {
            LogInternal("Play animated reaction failed", );
        }
    }
    else
    {
        fBioticMultiplier = GetBioticMultiplier(HitBioPawn);
        CheckBioticComboAchievement(OwnerPawn, HitBioPawn, m_bPlayerOrderedPowerUse);
        RemoveBioticEffects(HitBioPawn, TRUE);
        if (bUseOwnerRotation)
        {
            Momentum = Vector(OwnerPawn.Rotation);
        }
        else
        {
            Momentum = Normal(HitBioPawn.Location - OwnerPawn.Location) + vect(0.0, 0.0, 0.300000012);
        }
        Momentum = Normal(Momentum);
        Manager = HitBioPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            if (Manager.HasEffectOfType(Class'SFXGameEffect_DelayedCryoFreeze') || Manager.HasEffectOfType(Class'SFXGameEffect_CryoFreeze') && HitBioPawn.CollisionComponent != None)
            {
                HitBioPawn.CollisionComponent.AddForce(((Momentum * LocalPower.GetForce()) * fBioticMultiplier) * LocalPower.FrozenTargetForceMult, HitBioPawn.Location, BoneName);
            }
            else
            {
                HitBioPawn.AddRagdollImpulse((Momentum * LocalPower.GetForce()) * fBioticMultiplier, Outer.Instigator, , TRUE);
            }
        }
        if (GetPhysicsLevel(HitBioPawn) <= 0)
        {
            DmgModule = HitBioPawn.GetModule(Class'SFXModule_Damage');
            Parts = DmgModule.GetConstraints();
            if (Parts.Length > 0)
            {
                DmgModule.DestroyConstraint(Parts[Rand(Parts.Length)]);
            }
        }
        HitBioPawn.RegisterRBCallback(OnRagdollPhysicsImpact, TRUE);
    }
}
private final function DoImpact()
{
    local Pawn HitPawn;
    local BioPawn OwnerPawn;
    local BioPawn HitBioPawn;
    local bool bCachedTargetImpacted;
    local bool bAoEPower;
    local float fRadius;
    local float fDistance;
    
    fRadius = LocalPower.GetArrayValue(LocalPower.ImpactRadius);
    bAoEPower = SFXPower_BioticCharge_Radius(LocalPower) != None;
    OwnerPawn = BioPawn(Outer.Owner);
    if (OwnerPawn == None)
    {
        return;
    }
    bCachedTargetImpacted = FALSE;
    foreach Caster.CollidingActors(Class'Pawn', HitPawn, fRadius, , , , )
    {
        HitBioPawn = BioPawn(HitPawn);
        if (HitPawn != Caster && HitBioPawn.IsHostile(Caster))
        {
            if (bAoEPower || Vector(Caster.Rotation) Dot Normal(HitPawn.Location - Caster.Location) >= LocalPower.GetConeAngle())
            {
                if (HitBioPawn == CachedTarget)
                {
                    bCachedTargetImpacted = TRUE;
                }
                DoChargeImpact(OwnerPawn, HitBioPawn);
            }
        }
    }
    if (CachedTarget != None && !bCachedTargetImpacted)
    {
        LogInternal("Biotic Charge failed to hit initial target. Doing secondary attempt.", );
        fDistance = VSize(CachedTarget.Location - Caster.Location);
        if (fDistance < 275.0)
        {
            DoChargeImpact(OwnerPawn, BioPawn(CachedTarget), TRUE);
        }
        else
        {
            LogInternal("Biotic Charge initial target was too far during second attempt. " $ fDistance, );
        }
    }
}
public function Impact()
{
    local PlayerController PC;
    local float fShieldDuration;
    local float fShieldStrength;
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_GiveShield ShieldEffect;
    local BioVisualEffect ShieldVFX;
    local Emitter TeleportIn;
    
    if (ChargeProjectile != None)
    {
        ChargeProjectile.Destroy();
    }
    PC = PlayerController(Caster.Controller);
    if (PC == None)
    {
        return;
    }
    Caster.SetHidden(FALSE);
    Caster.CustomTimeDilation = 1.0;
    TeleportIn = SFXGame(Caster.WorldInfo.Game).ObjectPool.GetImpactEmitter(PS_TeleportIn, Caster.Location + Normal(Vector(Caster.Rotation)) * 50.0, Caster.Rotation);
    if (TeleportIn != None)
    {
        TeleportIn.ParticleSystemComponent.SetActive(TRUE);
    }
    if (!bFailedToMoveCaster)
    {
        DoImpact();
        Caster.SetTimer(TimeStingerDelay, FALSE, 'TimeStinger', Self);
        if (PC.PlayerCamera != None)
        {
            SFXPlayerCamera(PC.PlayerCamera).AddScreenShake(HitShake);
        }
        PC.ClientPlayForceFeedbackWaveform(HitForceFeedback);
        SFXGame(Caster.WorldInfo.Game).PlayTransientSound(ChargeImpact, Caster.Location);
        fShieldDuration = LocalPower.GetArrayValue(LocalPower.BioticShieldDuration);
        if (fShieldDuration > float(0))
        {
            Manager = Caster.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager != None)
            {
                fShieldStrength = LocalPower.GetArrayValue(LocalPower.BioticShieldStrength);
                ShieldEffect = SFXGameEffect_GiveShield(Manager.CreateEffect(Class'SFXGameEffect_GiveShield', LocalPower.Name, fShieldDuration, 1, fShieldStrength, Outer.Instigator));
                if (ShieldEffect != None)
                {
                    ShieldEffect.ShieldClass = Class'SFXShield_Biotic';
                    ShieldEffect.OnApplied();
                }
                ShieldVFX = Class'BioVisualEffect'.static.CreateVFXOnMesh(CrustEffect, Caster, 'None', fShieldDuration, , TRUE);
                if (ShieldVFX != None)
                {
                    ShieldVFX.SetState(0, TRUE);
                }
            }
        }
    }
    PC.IgnoreLookInput(FALSE);
    PC.IgnoreMoveInput(FALSE);
    bCollectedVolumes = FALSE;
}
public function Teleport()
{
    SpawnProjectile();
    FinalizePawnMove(CachedTeleportLocation, CachedTargetLocation);
    Caster.SetHidden(TRUE);
    Caster.SetPhysics(2);
}
public function StartTeleport()
{
    local SFXEmitter TeleportOut;
    
    TeleportOut = SFXEmitter(SFXGame(Caster.WorldInfo.Game).ObjectPool.GetImpactEmitter(PS_TeleportOut, Caster.Location, Caster.Rotation));
    if (TeleportOut != None)
    {
        TeleportOut.SetLifeTime(2.0);
        TeleportOut.ParticleSystemComponent.SetScale(0.25);
        TeleportOut.ParticleSystemComponent.SetActive(TRUE);
        TeleportOut.CustomTimeDilation = CounterTimeScaleValue;
    }
}
public function bool StartPhase(EBioPowerState ePhase, Actor oCaster, float fDuration)
{
    local PlayerController PC;
    local SFXPlayerCamera Camera;
    local float fDistanceToTarget;
    
    Super(BioPowerScript).StartPhase(ePhase, oCaster, fDuration);
    if (ePhase == EBioPowerState.BIO_POWER_CASTING)
    {
        if (m_oTargetToAimAt == None || Pawn(m_oTargetToAimAt) == None)
        {
            return FALSE;
        }
        bShouldTick = TRUE;
        BioPawn(oCaster).LeaveCover();
        bFailedToMoveCaster = FALSE;
        Caster = Pawn(oCaster);
        CachedTarget = Pawn(m_oTargetToAimAt);
        LocalPower = SFXPower_BioticCharge(Outer.NewPower);
        fDistanceToTarget = VSize(CachedTarget.Location - Caster.Location);
        fDistanceToTarget = FClamp(fDistanceToTarget / 4000.0, 0.0, 1.0);
        ImpactDelay = Lerp(ImpactDelay_Min, ImpactDelay_Max, fDistanceToTarget);
        LocalPower.CastingTime.X = ImpactDelay / CounterTimeScaleValue;
        LocalPower.CastingTime.Y = LocalPower.CastingTime.X;
        SFXGame(Caster.WorldInfo.Game).RequestTimeDilation(TimeCurve, ImpactDelay / CounterTimeScaleValue);
        oCaster.CustomTimeDilation = CounterTimeScaleValue;
        oCaster.SetTimer(TeleportStartDelay, FALSE, 'StartTeleport', Self);
        oCaster.SetTimer(TeleportDelay, FALSE, 'Teleport', Self);
        oCaster.SetTimer(ImpactDelay, FALSE, 'Impact', Self);
        ApplyTemporaryGameEffect(oCaster, Class'SFXGameEffect_DamageImmunity', ImpactDelay, 0.0, LocalPower.Name, Outer.Instigator);
        if (CamTransition == None)
        {
            CamTransition = new (Self) Class'SFXCameraTransition_VanguardSlam';
        }
        PC = PlayerController(Caster.Controller);
        if (PC != None)
        {
            CamTransition.TargetActor = m_oTargetToAimAt;
            CamTransition.FirstPhaseLength = TeleportDelay / CounterTimeScaleValue;
            Camera = SFXPlayerCamera(PC.PlayerCamera);
            if (Camera != None)
            {
                Camera.PlayCameraTransition(CamTransition, (ImpactDelay + CameraImpactDelay) / CounterTimeScaleValue);
            }
            PC.IgnoreLookInput(TRUE);
            PC.IgnoreMoveInput(TRUE);
        }
        SFXGame(Caster.WorldInfo.Game).PlayTransientSound(ChargeCast, Caster.Location);
    }
    return TRUE;
}
public function Tick(float DeltaTime)
{
    local int Idx;
    local array<SequenceEvent> EventsList;
    local SequenceEvent Event;
    local SeqEvent_Touch TouchEvent;
    local bool OldOverlapping;
    
    if (VolumeList.Length > 0)
    {
        for (Idx = 0; Idx < VolumeList.Length; Idx++)
        {
            if (VolumeList[Idx].bTouching == FALSE)
            {
                VolumeList[Idx].bTouching = TRUE;
                LogInternal((((((("(" $ Name) $ ") SFXPowerScript_BioticCharge::") $ GetStateName()) $ ":") $ GetFuncName()) @ "Triggering touch on") @ VolumeList[Idx].Volume, );
                if (VolumeList[Idx].Volume.FindEventsOfClass(Class'SeqEvent_Touch', EventsList))
                {
                    foreach EventsList(Event, )
                    {
                        TouchEvent = SeqEvent_Touch(Event);
                        if (TouchEvent != None)
                        {
                            OldOverlapping = TouchEvent.bForceOverlapping;
                            TouchEvent.bForceOverlapping = FALSE;
                            TouchEvent.CheckTouchActivate(Caster, Caster);
                            TouchEvent.bForceOverlapping = OldOverlapping;
                        }
                    }
                }
                break;
                continue;
            }
            LogInternal((((((("(" $ Name) $ ") SFXPowerScript_BioticCharge::") $ GetStateName()) $ ":") $ GetFuncName()) @ "Triggering untouch on") @ VolumeList[Idx].Volume, );
            if (VolumeList[Idx].Volume.FindEventsOfClass(Class'SeqEvent_Touch', EventsList))
            {
                foreach EventsList(Event, )
                {
                    TouchEvent = SeqEvent_Touch(Event);
                    if (TouchEvent != None)
                    {
                        TouchEvent.CheckUnTouchActivate(Caster, Caster);
                    }
                }
            }
            VolumeList.Remove(Idx, 1);
            Idx--;
        }
    }
    else
    {
        bShouldTick = FALSE;
    }
}
private final function FinalizePawnMove(out Vector Loc, optional out Vector TargetLoc)
{
    local Vector Dir;
    
    Caster.SetLocation(Loc);
    if (BioPawn(Caster) != None)
    {
        BioPawn(Caster).LeaveCover();
    }
    if (IsZero(TargetLoc) == FALSE)
    {
        Dir = TargetLoc - Loc;
        Dir.Z = 0.0;
        Dir = Normal(Dir);
        CachedTarget.SetLocation(TargetLoc);
        if (BioPawn(CachedTarget) != None)
        {
            BioPawn(CachedTarget).LeaveCover();
        }
    }
    else
    {
        Dir = CachedTarget.Location - Loc;
        Dir.Z = 0.0;
        Dir = Normal(Dir);
    }
}
public function bool ValidateTarget()
{
    local Vector NewLocation;
    local Vector NewTargetLocation;
    local Vector Dir;
    local float MoveDist;
    local BioPawn oTargetPawn;
    
    if (Caster.WorldInfo.TimeSeconds - CachedTarget.LastRenderTime > 0.5)
    {
        LogInternal("Rendertime threshold failed!", );
        return FALSE;
    }
    oTargetPawn = BioPawn(CachedTarget);
    if (oTargetPawn != None && !oTargetPawn.CanBeBioticCharged())
    {
        LogInternal("Not allowed to charge this type of pawn", );
        return FALSE;
    }
    Dir = CachedTarget.Location - Caster.Location;
    Dir.Z = 0.0;
    Dir = Normal(Dir);
    LogInternal((((((("Target:" @ CachedTarget) @ "Location:") @ CachedTarget.Location) @ "Caster:") @ Caster) @ "Location:") @ Caster.Location, );
    if (SFXAI_Core(CachedTarget.Controller) != None && SFXAI_Core(CachedTarget.Controller).CurrentCustomAction == EAICustomAction.AI_CustomAction_CoverMantle)
    {
        NewLocation = CachedTarget.Anchor.Location;
        NewLocation.Z -= CachedTarget.Anchor.CylinderComponent.CollisionHeight;
    }
    else
    {
        MoveDist = FMax(CachedTarget.CylinderComponent.CollisionRadius, Caster.CylinderComponent.CollisionRadius) + 120.0;
        NewLocation = CachedTarget.Location - Dir * MoveDist;
        NewLocation.Z -= CachedTarget.CylinderComponent.CollisionHeight;
    }
    NewLocation.Z += Caster.CylinderComponent.CollisionHeight;
    if (TryMove(NewLocation, Dir, Caster))
    {
        CachedTeleportLocation = NewLocation;
        CachedTargetLocation = vect(0.0, 0.0, 0.0);
        return TRUE;
    }
    NewLocation = CachedTarget.Location;
    NewLocation.Z += Caster.CylinderComponent.CollisionHeight - CachedTarget.CylinderComponent.CollisionHeight;
    NewTargetLocation = CachedTarget.Location + Dir * MoveDist;
    if (TryMove(NewLocation, Dir, CachedTarget))
    {
        CachedTeleportLocation = NewLocation;
        CachedTargetLocation = NewTargetLocation;
        return TRUE;
    }
    NewLocation = CachedTarget.Location + (Dir * MoveDist) * 0.5;
    NewLocation.Z += Caster.CylinderComponent.CollisionHeight - CachedTarget.CylinderComponent.CollisionHeight;
    NewTargetLocation = CachedTarget.Location + (Dir * MoveDist) * 1.5;
    if (TryMove(NewLocation, Dir, CachedTarget))
    {
        CachedTeleportLocation = NewLocation;
        CachedTargetLocation = NewTargetLocation;
        return TRUE;
    }
    LogInternal("Couldn't find a spot :(", );
    return FALSE;
}
public function bool FindSpace(out Vector NearLocation, Vector Extent, Actor TraceActor)
{
    local Vector HitLocation;
    local Vector HitNormal;
    local Vector UnitX;
    local Vector UnitY;
    
    UnitX.X = Extent.X * 0.5;
    UnitY.Y = Extent.Y * 0.5;
    if (TraceActor.Trace(HitLocation, HitNormal, NearLocation, NearLocation, FALSE, Extent, , , ) == None)
    {
        return TRUE;
    }
    if (TraceActor.Trace(HitLocation, HitNormal, NearLocation + UnitX, NearLocation + UnitX, FALSE, Extent, , , ) == None)
    {
        NearLocation = NearLocation + UnitX;
        return TRUE;
    }
    if (TraceActor.Trace(HitLocation, HitNormal, NearLocation - UnitX, NearLocation - UnitX, FALSE, Extent, , , ) == None)
    {
        NearLocation = NearLocation - UnitX;
        return TRUE;
    }
    if (TraceActor.Trace(HitLocation, HitNormal, NearLocation + UnitY, NearLocation + UnitY, FALSE, Extent, , , ) == None)
    {
        NearLocation = NearLocation + UnitY;
        return TRUE;
    }
    if (TraceActor.Trace(HitLocation, HitNormal, NearLocation - UnitY, NearLocation - UnitY, FALSE, Extent, , , ) == None)
    {
        NearLocation = NearLocation - UnitY;
        return TRUE;
    }
    return FALSE;
}
public function bool TryMove(Vector NewLocation, Vector Dir, Pawn CollisionActor)
{
    if (!FindSpace(NewLocation, Caster.CylinderComponent.Bounds.BoxExtent, Caster))
    {
        return FALSE;
    }
    if (!ValidateTargetLocation(NewLocation))
    {
        return FALSE;
    }
    return TRUE;
}
public function CollectVolumes()
{
    local PlayerController PC;
    local TriggerVolume ChkVolume;
    local array<TriggerVolume> AllVolumes;
    local NavigationPoint Nav;
    local NavigationPoint TargetNav;
    local int Idx;
    local int VolumeIdx;
    local Charge_PendingVolume NewVolume;
    local Vector Extent;
    
    PC = PlayerController(Caster.Controller);
    if (PC == None)
    {
        return;
    }
    VolumeList.Length = 0;
    foreach Caster.AllActors(Class'TriggerVolume', ChkVolume, )
    {
        if (ChkVolume.IsA('BioTriggerStream') == FALSE && Caster.IsInVolume(ChkVolume) == FALSE)
        {
            AllVolumes.AddItem(ChkVolume);
        }
    }
    LogInternal((((((((("(" $ Name) $ ") SFXPowerScript_BioticCharge::") $ GetStateName()) $ ":") $ GetFuncName()) @ "Num Triggers:") @ AllVolumes.Length) @ "Path Length:") @ PC.RouteCache.Length, );
    Extent = Caster.GetCollisionExtent();
    foreach PC.RouteCache(Nav, Idx)
    {
        if (Idx < PC.RouteCache.Length - 1)
        {
            TargetNav = PC.RouteCache[Idx + 1];
            for (VolumeIdx = AllVolumes.Length - 1; VolumeIdx >= 0; VolumeIdx--)
            {
                ChkVolume = AllVolumes[VolumeIdx];
                if (ChkVolume.bCollideActors && ChkVolume.LineCheck(Nav.Location, TargetNav.Location, Extent))
                {
                    LogInternal((((((("(" $ Name) $ ") SFXPowerScript_BioticCharge::") $ GetStateName()) $ ":") $ GetFuncName()) @ "Adding:") @ PathName(ChkVolume), );
                    NewVolume.Volume = ChkVolume;
                    NewVolume.bTouching = FALSE;
                    VolumeList.AddItem(NewVolume);
                    AllVolumes.Remove(VolumeIdx, 1);
                }
            }
        }
    }
    bCollectedVolumes = TRUE;
}
public final function bool ValidateTargetLocation(Vector TargetLocation)
{
    local NavigationPoint TargetAnchor;
    local NavigationPoint Nav;
    local Actor FirstTarget;
    local float DistToAnchor;
    local PlayerController PC;
    local float CylHeight;
    local float CylWidth;
    
    if (Abs(TargetLocation.Z - Caster.Location.Z) > 1000.0)
    {
        LogInternal("Height threshold failed!", );
        return FALSE;
    }
    CylHeight = Caster.CylinderComponent.CollisionHeight;
    CylWidth = Caster.CylinderComponent.CollisionRadius;
    if (CachedTarget.FastTrace(TargetLocation + NewVector(0.0, 0.0, -CylHeight * float(4)), TargetLocation, NewVector(CylWidth, CylWidth, 0.0), FALSE))
    {
        LogInternal("Too high above ground.", );
        FailedLineCheckStart = TargetLocation + NewVector(0.0, 0.0, -CylHeight * float(4));
        FailedLineCheckEnd = TargetLocation;
        FailedLineCheckName = "Failed ground test";
        return FALSE;
    }
    TargetAnchor = CachedTarget.Anchor;
    if (TargetAnchor == None || !TestPathReachability(TargetLocation, TargetAnchor, NewVector(CylWidth, CylWidth, CylHeight * 0.75)))
    {
        TargetAnchor = CachedTarget.GetBestAnchor(CachedTarget, TargetLocation, TRUE, TRUE, DistToAnchor);
        if (TargetAnchor == None)
        {
            LogInternal("Off path network", );
            return FALSE;
        }
        if (!TestPathReachability(TargetLocation, TargetAnchor, NewVector(CylWidth, CylWidth, CylHeight * 0.75)))
        {
            return FALSE;
        }
    }
    Nav = Caster.GetBestAnchor(Caster, Caster.Location, TRUE, TRUE, DistToAnchor);
    if (Nav == None)
    {
        LogInternal("Unable to find anchor for player!", );
        return FALSE;
    }
    if (Nav.NetworkID != TargetAnchor.NetworkID)
    {
        LogInternal("Network ID test failed!", );
        return FALSE;
    }
    PC = PlayerController(Caster.Controller);
    if (PC != None)
    {
        Caster.SetAnchor(Nav);
        if (Class'Goal_AtActor'.static.AtActor(Caster, TargetAnchor, 0.0, FALSE))
        {
            Class'Path_TowardGoal'.static.TowardGoal(Caster, TargetAnchor);
            FirstTarget = PC.FindPathToward(TargetAnchor, , , );
        }
        Caster.SetAnchor(None);
    }
    if (FirstTarget == None)
    {
        LogInternal("Pathfind test failed!", );
        return FALSE;
    }
    if (bCollectedVolumes == FALSE)
    {
        CollectVolumes();
    }
    return TRUE;
}
public final function bool TestPathReachability(const out Vector StartLocation, NavigationPoint Anchor, Vector Extent)
{
    local Vector AnchorLocation;
    
    AnchorLocation = Anchor.Location;
    AnchorLocation.Z -= Anchor.CylinderComponent.CollisionHeight;
    AnchorLocation.Z += Caster.CylinderComponent.CollisionHeight + 2.0;
    if (!FindSpace(AnchorLocation, Extent, Caster))
    {
        LogInternal("Failed to find spot around nav", );
        FailedLineCheckStart = AnchorLocation - Extent;
        FailedLineCheckEnd = AnchorLocation + Extent;
        FailedLineCheckName = "Failed to find spot around nav";
        return FALSE;
    }
    if (!CachedTarget.FastTrace(AnchorLocation, StartLocation, Extent, FALSE))
    {
        LogInternal("Failed path network reachability", );
        FailedLineCheckStart = AnchorLocation;
        FailedLineCheckEnd = StartLocation;
        FailedLineCheckName = "Failed target to nav";
        return FALSE;
    }
    return TRUE;
}
public final function Vector NewVector(float X, float Y, float Z)
{
    local Vector V;
    
    V.X = X;
    V.Y = Y;
    V.Z = Z;
    return V;
}
public event function bool CanStartPower(Actor oCaster)
{
    local BioPlayerController PC;
    local Vector TargetLocation;
    
    Caster = Pawn(oCaster);
    if (Caster != None && Caster.IsHumanControlled())
    {
        PC = BioPlayerController(Caster.Controller);
        if (PC != None)
        {
            CachedTarget = BioPawn(PC.m_oPlayerSelection.m_oCurrentSelectionTarget);
            if ((CachedTarget != None && Caster.IsHostile(CachedTarget)) && ValidateTarget())
            {
                BioPawn(CachedTarget).GetAimNodeLocation(1, TargetLocation);
                if (bLineCheckToHead && Caster.FastTrace(TargetLocation, PC.PlayerCamera.CameraCache.POV.Location, , ))
                {
                    return TRUE;
                }
                else
                {
                    FailedLineCheckStart = TargetLocation;
                    FailedLineCheckEnd = PC.PlayerCamera.CameraCache.POV.Location;
                    FailedLineCheckName = "Failed visibility test to head. Will try chest next.";
                    BioPawn(CachedTarget).GetAimNodeLocation(4, TargetLocation);
                    if (Caster.FastTrace(TargetLocation, PC.PlayerCamera.CameraCache.POV.Location, , ))
                    {
                        return TRUE;
                    }
                    else
                    {
                        FailedLineCheckStart = TargetLocation;
                        FailedLineCheckEnd = PC.PlayerCamera.CameraCache.POV.Location;
                        FailedLineCheckName = "Failed visibility test to chest";
                    }
                }
            }
        }
    }
    PlayFailedChargeEffects();
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
    End Template
    Begin Object Class=ForceFeedbackWaveform Name=HitShakeFF0
        Samples = ({Duration = 0.200000003, LeftAmplitude = 0, RightAmplitude = 100, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Sin0to90}, 
                   {Duration = 0.349999994, LeftAmplitude = 60, RightAmplitude = 60, LeftFunction = EWaveformFunction.WF_LinearDecreasing, RightFunction = EWaveformFunction.WF_LinearDecreasing}
                  )
    End Object
    TimeCurve = {
                 Points = ({InVal = 0.0, OutVal = 0.200000003, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                           {InVal = 1.0, OutVal = 0.200000003, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}
                          ), 
                 InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                }
    HitShake = {
                RotAmplitude = {X = 500.0, Y = 500.0, Z = 500.0}, 
                RotFrequency = {X = 100.0, Y = 100.0, Z = 100.0}, 
                RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                LocAmplitude = {X = 0.0, Y = 0.0, Z = 0.0}, 
                LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                ShakeName = 'SlamImpact', 
                TimeToGo = 0.0, 
                TimeDuration = 0.550000012, 
                RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                FOVAmplitude = 0.0, 
                FOVFrequency = 5.0, 
                FOVSinOffset = 0.0, 
                FOVParam = EShakeParam.ESP_OffsetRandom
               }
    PS_TeleportIn = ParticleSystem'BioVFX_B_Vanguard.Particles.Charge_Blast'
    PS_TeleportOut = ParticleSystem'BioVFX_Crt_Praetorian.Particles.Teleport__out'
    CrustEffect = BioVFXTemplate'BioVFX_B_Lift.VFX.LiftCrust_VFX'
    HitForceFeedback = HitShakeFF0
    ChargeCast = WwiseEvent'Wwise_VFX_Biotics.Play_vfx_biotic_charge_cast'
    ChargeImpact = WwiseEvent'Wwise_VFX_Biotics.Play_vfx_biotic_charge_imp'
    TeleportStartDelay = 0.5
    TeleportDelay = 0.866699994
    ImpactDelay_Min = 1.10000002
    ImpactDelay_Max = 1.79999995
    TimeStingerDelay = 0.300000012
    CounterTimeScaleValue = 5.0
    CameraImpactDelay = 0.5
    bLineCheckToHead = TRUE
    m_ImpactWaveForm = ForceFeedbackWaveformBase
}