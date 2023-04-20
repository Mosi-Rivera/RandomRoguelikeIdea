local screen = require('config.screen');
local interface = {};
local NUM_CARDS = 20
local CARDS_TO_DISPLAY = 3
local CARD_WIDTH = 30
local CARD_HEIGHT = 45
local CARD_RADIUS = 45
local CENTER_X = -math.floor(CARD_WIDTH * 0.3);
local CENTER_Y = math.floor(screen.virtual_height - CARD_HEIGHT * 0.9);

local shift_buffer = 0;
local shift_dir_right = false;
local scrolling_right;
local current_index = 1
local target_index = 1
local shift_timer = 0
local SHIFT_DURATION = 0.2
local last_hand_size;
local cards = {}
local hand;
local stack;
local discard;

local function newHand()
    hand = {};
    for i = 1, #cards do
        hand[i] = cards[i];
    end
    last_hand_size = #hand;
end

local  function shiftLeft(force)
    target_index = current_index - 1;
    scrolling_right = false;
    if target_index < 1 then
        target_index = #hand;
    end
    if force then
        current_index = target_index;
    end
end

local function shiftRight(force)
    target_index = current_index + 1;
    scrolling_right = true;
    if target_index > #hand then
        target_index = 1;
    end
    if force then
        current_index = target_index;
    end
end

local function mergeDiscard()
    for i = 1, #discard do
        table.insert(cards, table.remove(discard, i));
    end
end

local function popCard()
    if #hand == 0 then return end
    local return_value = table.remove(hand, current_index);
    if #hand == 0 then
        newHand();
    end
    shiftLeft(true);
    return return_value;
end

local function addToStack()
    local _stack;
    if #hand ~= 0 and #stack < 3 then
        table.insert(stack, popCard());
    elseif #stack ~= 0 then
        _stack = stack;
        stack = {};
        return (_stack);
    end
end

function interface.update(dt)
    shift_buffer = shift_buffer - dt;
    if KEYBOARD_MANAGER.wasPressed('shift_left') then
        shift_buffer = SHIFT_DURATION * 2;
        shift_dir_right = false;
    elseif KEYBOARD_MANAGER.wasPressed('shift_right') then
        shift_buffer = SHIFT_DURATION * 2;
        shift_dir_right = true;
    end

    if last_hand_size ~= #hand then
        shift_timer = shift_timer + dt;
        if shift_timer >= SHIFT_DURATION then
            last_hand_size = #hand;
            shift_timer = 0;
        end
    elseif current_index ~= target_index then
        shift_timer = shift_timer + dt
        if shift_timer >= SHIFT_DURATION then
            current_index = target_index
            shift_timer = 0
        end
    else
        if shift_buffer > 0 then
            shift_buffer = 0;
            if shift_dir_right then
                shiftRight();
            else
                shiftLeft();
            end
        end
    end
end

local function calculate_card_position(index)
    if current_index ~= target_index then
        index = index + (not scrolling_right and shift_timer / SHIFT_DURATION or - (shift_timer / SHIFT_DURATION));
    elseif last_hand_size ~= #hand then
        index = index + (index < 2 and -1 + shift_timer / SHIFT_DURATION or 0);
    end
    local angle = math.rad((120 / CARDS_TO_DISPLAY) * index);
    local x = CENTER_X + CARD_RADIUS * math.cos(angle)
    local y = CENTER_Y - CARD_RADIUS * math.sin(angle)
    return x, y, angle
end

local function drawCardBefore(offset, position)
    offset = offset or 1;
    local index = current_index - offset;
    if index < 1 then
        index = #hand + index;
    end
    if index == current_index then return end
    local x, y = calculate_card_position(position or 0)
    SCALE_MANAGER.drawQuad(
            SPRITE_MANAGER.getSprite('card_frame'),
            SPRITE_MANAGER.getQuads('card_frame')[hand[index].type],
            x, y);
end

local function drawCardAfter(offset, position)
    offset = offset or 1;
    local index = current_index + offset;
    if index > #hand then
        index = math.max(1,index % #hand);
    end
    if index == current_index or index == current_index - 1 then return end
    local x, y = calculate_card_position(position or 2);
    SCALE_MANAGER.drawQuad(
            SPRITE_MANAGER.getSprite('card_frame'),
            SPRITE_MANAGER.getQuads('card_frame')[hand[index].type],
            x, y);
end

local function drawCardCurrent()
    local x, y = calculate_card_position(1)
    if hand[current_index] == nil then return end
    SCALE_MANAGER.drawQuad(
            SPRITE_MANAGER.getSprite('card_frame'),
            SPRITE_MANAGER.getQuads('card_frame')[hand[current_index].type],
            x, y);
end

local function drawStack()
    for i = 1, #stack do
        SCALE_MANAGER.drawQuad(
            SPRITE_MANAGER.getSprite('card_frame'),
            SPRITE_MANAGER.getQuads('card_frame')[stack[i].type],
            (i - 1) *  CARD_WIDTH, 5);
    end
end

local function printCardBefore(offset, position)
    offset = offset or 1;
    local index = current_index - offset;
    if index < 1 then
        index = #hand + index;
    end
    if index == current_index then return end
    local x, y = calculate_card_position(position or 0)
    SCALE_MANAGER.print(
            hand[index].cp,
            x + CARD_WIDTH - 11,
            y + CARD_HEIGHT - 10,
            11,
            'center',
            G_WHITE_COLOR
    );
end

local function printCardAfter(offset, position)
    offset = offset or 1;
    local index = current_index + offset;
    if index > #hand then
        index = math.max(1,index % #hand);
    end
    if index == current_index or index == current_index - 1 then return end
    local x, y = calculate_card_position(position or 2);
    SCALE_MANAGER.print(
            hand[index].cp,
            x + CARD_WIDTH - 11,
            y + CARD_HEIGHT - 10,
            11,
            'center',
            G_WHITE_COLOR
    );
end

local function printCardCurrent()
    local x, y = calculate_card_position(1)
    if hand[current_index] == nil then return end
    SCALE_MANAGER.print(
            hand[current_index].cp,
            x + CARD_WIDTH - 11,
            y + CARD_HEIGHT - 10,
            11,
            'center',
            G_WHITE_COLOR
    );
end

local function printStack()
    for i = 1, #stack do
        SCALE_MANAGER.print(
            stack[i].cp,
            (i - 1) * CARD_WIDTH + CARD_WIDTH - 11,
            5 + CARD_HEIGHT - 10,
            11,
            'center',
            G_WHITE_COLOR
    );
    end
end

function interface.draw()
    if current_index ~= target_index then
        if not scrolling_right then
            drawCardBefore(2, -1);
        else
            drawCardAfter(2, 3);
        end
    end
    drawCardBefore();
    drawCardAfter();
    drawCardCurrent();
    drawStack();
    SCALE_MANAGER.finish();
    if current_index ~= target_index then
        if not scrolling_right then
            printCardBefore(2, -1);
        else
            printCardAfter(2, 3);
        end
    end
    printCardBefore();
    printCardAfter();
    printCardCurrent();
    printStack();
    SCALE_MANAGER.start();
    -- for i = 1, #hand do
    --     if current_index == i then
    --         love.graphics.rectangle('fill', (i - 1) * CARD_WIDTH, CARD_HEIGHT * 2 + 10, CARD_WIDTH, 3);
    --     end
    --     SCALE_MANAGER.drawQuad(
    --         SPRITE_MANAGER.getSprite('card_frame'),
    --         SPRITE_MANAGER.getQuads('card_frame')[hand[i].type],
    --         (i - 1) *  CARD_WIDTH, CARD_HEIGHT + 10);
    -- end
end

function interface.init(_cards)
    cards = _cards;
    stack = {};
    discard = {};
    newHand();
end

function interface.dispose()
    cards = nil;
    stack = nil;
    discard = nil;
    hand = nil;
end

function interface.stack()
    return (addToStack());
end

function interface.isStackFull()
    return (#stack == 3);
end

function interface.popCard()
    return (popCard());
end

return (interface);