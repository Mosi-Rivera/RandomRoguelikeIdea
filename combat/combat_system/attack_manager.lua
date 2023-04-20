local interface = {};
local card_manager = require('combat.card_system.card_manager');
local attacks = require('combat.attacks.attacks');
local event = require('combat.combat_system.event');
local card = require('combat.card_system.card');
local attacks_cache = nil;
local attack_buffer;
local stack_buffer;
local C_BUFFER_TIME = 0.3;
local current_attack;

function interface.init()
    local _cards = RUN_INTERFACE.get().cards;
    attack_buffer = 0;
    stack_buffer = 0;
    attacks_cache = {};
    for i = 1, #_cards do
        interface.loadAttack(card.dataToCard(_cards[i]));
    end
end

function interface.loadAttack(attack)
    attacks_cache[attacks.dataToFileNameStr(attack.subtype, attack.type)] = attacks.get(attack.subtype, attack.type);
end

local function handleAttack(attack)
    local events = COMBAT_SYSTEM.getEvents();
    local cp = attack.cp;
    attack = attacks_cache[attacks.dataToFileNameStr(attack.subtype, attack.type)];
    if attack then
        current_attack = attack;
        event.addEvent(events, attack(COMBAT_SYSTEM.getCharacter(), cp));
    end
end

local function handleAttackStack(stack)
    local event_stack = {};
    local attack;
    local count = 0;
    local _character = COMBAT_SYSTEM.getCharacter();
    for i = 1, #stack do
        attack = attacks_cache[attacks.dataToFileNameStr(stack[i].subtype, stack[i].type)];
        if attack then
            count = count + stack[i].cp;
            table.insert(event_stack, attack);
        end
    end
    if #stack == 0 then return end
    event_stack = event.newStack(event_stack, _character, stack);
    current_attack = event_stack;
    event.addEvent(COMBAT_SYSTEM.getEvents(), event_stack);
end

function interface.cancelAttackCast()
    if current_attack then
        event.removeEvent(COMBAT_SYSTEM.getEvents(), current_attack);
    end
end

local function canCastSpell(character)
    return not (
        character.stunned or character.silenced or character.moving or character.cast_lock
    );
end

function interface.update(dt)
    attack_buffer = attack_buffer - dt;
    stack_buffer = stack_buffer - dt;
    if KEYBOARD_MANAGER.wasPressed('accept') then
        attack_buffer = C_BUFFER_TIME;
        stack_buffer = 0;
    elseif KEYBOARD_MANAGER.wasPressed('deny') then
        attack_buffer = 0;
        stack_buffer = C_BUFFER_TIME;
    end
    if stack_buffer > 0 and not (card_manager.isStackFull() and not canCastSpell(COMBAT_SYSTEM.getCharacter())) then
        stack_buffer = 0;
        local stack = card_manager.stack();
        if stack then
            handleAttackStack(stack);
        end
    elseif attack_buffer > 0 and canCastSpell(COMBAT_SYSTEM.getCharacter()) then
        attack_buffer = 0;
        local attack = card_manager.popCard();
        if attack then
            handleAttack(attack);
        end
    end
end

function interface.dispose()
    stack_buffer = nil;
    attack_buffer = nil;
end

return (interface);