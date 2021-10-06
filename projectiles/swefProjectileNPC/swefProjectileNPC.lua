require "/scripts/vec2.lua"
require "/scripts/util.lua"

function update()
  if not sourceEntityAlive() then
    projectile.die()
  end

  local velocity = mcontroller.velocity()
  if vec2.mag(velocity) < 0.1 then
    projectile.die()
  end
end

function destroy()
  if not sourceEntityAlive() then
    return
  end

	local npcSpawnPosition = {mcontroller.xPosition(), mcontroller.yPosition() + 2} --mcontroller.position()
	local npcSpecies = util.randomFromList(config.getParameter("npcSpecies"))
	local npcType = util.randomFromList(config.getParameter("npcType"))
	local npcThreatLevelmin = config.getParameter("npcThreatLevelmin")
	local npcThreatLevelmax = config.getParameter("npcThreatLevelmax")
	local npcThreatLevel
	local npcSeed = math.randomseed(util.seedTime())
	local npcParameters = {}
	
	if npcThreatLevelmin < 1 and npcThreatLevelmax < 1 then
		npcThreatLevel = world.threatLevel()
	  elseif npcThreatLevelmin >= 1 and npcThreatLevelmax < 1 then
		npcThreatLevel = world.threatLevel()
	  elseif npcThreatLevelmin > npcThreatLevelmax then
		npcThreatLevel = world.threatLevel()
	  else
		npcThreatLevel = math.random(npcThreatLevelmin,npcThreatLevelmax)
	  end
    
	world.spawnNpc(npcSpawnPosition, npcSpecies, npcType, npcThreatLevel, npcSeed, npcParameters)
	
	--local EntityId = world.spawnNpc(npcSpawnPosition, npcSpecies, npcType, npcThreatLevel, npcSeed, npcParameters)
    --world.callScriptedEntity(EntityId, "status.addEphemeralEffect", "beamin")
    
end

function sourceEntityAlive()
  return world.entityExists(projectile.sourceEntity()) and world.entityHealth(projectile.sourceEntity())[1] > 0
end