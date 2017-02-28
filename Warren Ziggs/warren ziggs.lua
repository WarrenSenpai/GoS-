if myHero.charName ~= "Ziggs" then return end

require "DamgeLib"

-- Spells

Q = {Delay = 0.05, Range = 1400, Radius = 180, Speed = 1700, Collision = true}
W = {Delay = 0.05, Range = 1000, Radius = 325, Speed = 1700, Collision = false}
E = {Delay = 0.05, Range = 900, Radius = 325, Speed = 1700, Collision = false}
R = {Delay = 0.05, Range = 5300, Radius = 550, Speed = math.huge, Collision = false}

-- Menu

Menu = MenuElement({type = MENU, id = "Ziggs", name = "Warren - WarrenZiggs", lefticon="https://digitumart.files.wordpress.com/2015/07/pepe-angry.jpg"})

-- [[Keys]]

Menu:MenuElement({type = MENU, id = "Key", name = "Key Settings"})
Menu.Key:MenuElement({id = "ComboKey", name = "Combo Key", key = 32})
Menu.Key:MenuElement({id = "HarrasKey", name = "Harass Key", key = 67})
Menu.Key:MenuElement({id = "FarmKey", name = "Farm Key", key = 86})
Menu.Key:MenuElement({id = "LastHitKey", name = "Last Hit Key", key = 88})

-- [[Combo]]
Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
Menu.Combo:MenuElement({id = "ComboQ", name = "Use Q", value = true})
Menu.Combo:MenuElement({id = "ComboW", name = "Use W", value = true})
Menu.Combo:MenuElement({id = "ComboE", name = "Use E", value = true})

-- [[Harrass]]
Menu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})
Menu.Harass:MenuElement({id = "HarassQ", name = "Use Q", value = true})
Menu.Harass:MenuElement({id = "HarassW", name = "Use W", value = true})
Menu.Harras:MenuElement({id = "HarrassE", name = "Use E", value = true})

-- [[Farm]]
Menu:MenuElement({type = MENU, id = "Farm", name = "Farm Settings"})
Menu.Farm:MenuElement({id = "FarmSpells", name = "Farm Spells", value = true})
Menu.Farm:MenuElement({id = "FarmQ", name = "Use Q", value = true})
Menu.Farm:MenuElement({id = "FarmE", name = "Use E", value = true})



-- GetTarget - Returns target
function GetTarget(targetRange)
  local result 
  for i = 1, Game.HeroCount() do
    local hero = Game.Hero(i)
    if isValidTarget(hero, targetRange) and hero.team ~= myHero.team then 
      result = hero
      break 
    end
  end
  return result
end

function GetFarmTarget(minionRange)
  local getFarmTarget
  for j = 1,Game.MinionCount() do
    local minion = Game.Minion(j)
    if isValidTarget(minion, minionRange) and minion.team ~= myHero.team then
      getFarmTarget = minion 
      break
    end
  end
  return getFarmTarget
end

-- [Events]
-- OnUpdate
Callback.add('Tick', function()
    
    if Menu.Key.Combokey:Value() then
      if isReady(_Q) and Menu.Combo.ComboQ:value() then
        local qTarget = GetTarget(Q.Range:value())
        if qTarget and qTarget:GetCollision(Q.Radius, Q.Speed, Q.Delay) == 0 then
          local qPos = qTarget:GetPrediction(Q.Speed, Q.Delay)
          Control.CastSpell(HK_Q, qPos)
        end
      end
      if isReady(_W) and Menu.Combo.ComboW:Value() then
        local wTarget = GetTarget(W.Range:Value())
        if wTarget then 
          local wPos = Target:GetPrediction(W.Speed, W.Delay)
          Control.CastSpell(HK_W, wPos)
        end
      end
      
      if Menu.Key.HarassKey:Value() then
        if isReady(_Q) and Menu.Harass.HarassQ:value() then
          local qTarget = GetTarget(Q.Range:Value())
          if qTarget and qTarget:GetCollision(Q.Radius, Q.Speed, Q.Delay) == 0 then
            local qPos = qTarget:GetPrediction(Q.Speed, Q.Delay) 
            Control.CastSpell(HK_Q, qPos)
          end
        end
        if isReady(_W) and Menu.Harass.HarassW:Value() then 
          local wTarget = GetTarget(W.Range:Value())
          if wTarget then
            local wPos = wTarget:GetPrediction(W.Speed, W.Delay)
            Control.CastSpell(HK_W, wPos)
          end
        end
      end
    
    --OnLoad
    Callback.Add('Load',function())
        PrintChat("Warrens Ziggs - Loaded")
      end
    end
  end
   
   function isReady(slot)
     return (myHero:GetSpellData(slot).currentCd == 0) and (GetSpellData(spellSlot).mana < myHero.mana) and (myHero:GetSpellData(slot).level >= 1)
   end
   
   function isValidTarget(obj, spellRange)
     return obj ~= nil and obj.valid and obj.visible and not obj.dead and obj.isTargetable and obj.distance <= spellRange
   end
   
