%Greet the adventurer (take name & assign to a variable to be personalized)
global player;
player.Name = input('What is your name, Adventurer?\n\n', 's');
if strcmp(player.Name,'Newman')
    fprintf('\n\nHello Newman. Are you headed to the store to get some goods to head West?\n');
else
    fprintf("\n\nWelcome to St. Louis %s! Before you head out west, care to stop in the general store for some goods before you leave?\n", player.Name);
end
timesAsking = 0;
while true
    global shop;
    
    if timesAsking > 0
        fprintf("\nWould you like to visit our general store to stock up?\n");
    end
    
    shop.Selection = input('Yes or No\n\n','s');
    
    if strcmp(shop.Selection, 'Yes') || strcmp(shop.Selection, 'yes')
        fprintf("\nSplendid! What can I get you?\n");
        generalStore;
        shop.Selection = 1;
        break;
    elseif strcmp(shop.Selection, 'No') || strcmp(shop.Selection, 'no')
        if strcmp(player.Name,'Newman')
            fprintf('\nI hope you make it to your destination! Goodbye Newman!');
        else
            fprintf("\nAlright %s, it is your choice! I wish you the best of luck on your treacherous journey ahead of you.\n", player.Name);
        end
        adventure;
        break;
    else
        fprintf('\nI am happy you are excited, but a yes or no will suffice.\n');
        timesAsking = timesAsking + 1;
        continue;
    end
end

% Code used to simulate adventure without having to show all of the boring
    %days

function [] = adventure(source,event)
   
    global shop;
    global player;

    if shop.Selection == 1
       close 'The General Store';
    end
   
    %Other needed variables
    player.daysTraveled = 0;
    player.daysStarving = 0;
    bulletsNeededforBuffalo = randi([1 24]);
    player.isDead = false;
    player.isWon = false;
    player.isDone = false;
    player.finalDestination = ' ';
    poundsofBuffaloMeat = randi([125 250]);
    player.daysInfected= 0;
    player.bodyFightInfection = randi([0 1]);
    eventDecision = randi([1 6]);

    while(player.isDead == false) && (player.isWon == false) && (player.daysInfected < 10) && (player.isDone == false)
        
        checkEndGame;
        
        player.daysTraveled = player.daysTraveled + 1;
        
        if player.daysTraveled <= 2
            player.finalDestination = 'Missouri';
        elseif player.daysTraveled <= 5 && player.daysTraveled > 2
            player.finalDestination = 'Kansas';
        elseif player.daysTraveled <= 8 && player.daysTraveled > 5
            player.finalDestination = 'Nebraska';
        elseif player.daysTraveled <= 11 && player.daysTraveled > 8
            player.finalDestination = 'Wyoming';
        elseif player.daysTraveled <= 14 && player.daysTraveled > 11
            player.finalDestination = 'Idaho';
        elseif player.daysTraveled <= 17 && player.daysTraveled > 14
            player.finalDestination = 'Eastern Oregon';
        elseif player.daysTraveled <= 20 && player.daysTraveled > 17
            player.finalDestination = 'Washington';
        elseif player.daysTraveled <= 23 && player.daysTraveled > 20
            player.finalDestination = 'Western Oregon';
        end
        
        eventDecision = randi([1 6]);
        
        %Function to determine if the user a) has an infection and b) has
            %recovered from it (with either medicine or luck)
        if player.daysInfected > 0 && player.bodyFightInfection ~= 42 && shop.thunderclappers == 0
            player.daysInfected = player.daysInfected + 1;
            player.bodyFightInfection = randi([0 100]);
        elseif player.daysInfected > 0 && player.bodyFightInfection == 42
            fprintf('\nMiraculously, your body healed from the infection and you make a full recovery!\n');
            player.daysInfected = 0;
            player.bodyFightInfection = randi([0 100]);
        elseif player.daysInfected > 0 && player.bodyFightInfection ~= 42 && shop.thunderclappers >= 2
            fprintf('\nThanks to the medical marvel that is Dr. Benjamin Rush''s Famous Thunderclappers, you make a full recovery from your infection!\n');
            player.daysInfected = 0;
            shop.thunderclappers = shop.thunderclappers - 2;
            player.bodyFightInfection = randi([0 100]);
        end
        
        if shop.food > 0
            shop.food = shop.food - 5;
        end
        
        fprintf('\nDays traveled: %d\n',player.daysTraveled);
        fprintf('Available foodstores: %d\n',shop.food);
        fprintf('Bullets owned: %d\n',shop.bullets);
        fprintf('Thunderclappers owned: %d\n',shop.thunderclappers); 
        fprintf('Your current location: %s\n\n',player.finalDestination);
        
        if shop.food <= 0
            player.daysStarving = player.daysStarving + 1;
            if player.daysStarving >= 8
                fprintf('Unfortunately you have run out of food. You have died of starvation.\n');
                player.isDead = true;
            end
        end
        
        if (player.daysTraveled == 24) && (player.isDead == false)
            player.finalDestination = 'Portland, Oregon';
            player.isWon = true;
        end
        if (eventDecision <= 3) && (eventDecision >= 1)
            fprintf('Nothing happended during your day\n');
            goOn;
        elseif (eventDecision == 4) 
            fprintf('You spot some wild buffalo in the distance. Do you want to go hunting for some buffalo to try and gather some food?\n');
            while true    
                buffaloChoice = input('Yes or No\n\n','s');
                if strcmp(buffaloChoice,'Yes') || strcmp(buffaloChoice, 'yes')
                    fprintf('\nYour party sets off to go hunt the buffalo and gather some food.\n');
                    killedbyBuffalo = randi([0 1]);
                    if (bulletsNeededforBuffalo <= shop.bullets) && (killedbyBuffalo == 0)
                        fprintf('Your party successfully shot some buffalo and gathered up the food. You split the meat among the party, and everyone gets %d pounds of food.\n',poundsofBuffaloMeat);
                        shop.food = shop.food + poundsofBuffaloMeat;
                        shop.bullets = shop.bullets - bulletsNeededforBuffalo;
                        bulletsNeededforBuffalo = randi([1 24]);
                        poundsofBuffaloMeat = randi([125 250]);
                        goOn;
                        break;
                    elseif (bulletsNeededforBuffalo <= shop.bullets) && (killedbyBuffalo == 1)
                        fprintf('\nYour party went hunting for some buffalo, but the buffalo picked up your scent. They charged you and your party. You were able to kill some, but not all. You took a slight grazing by a buffalo, and manage to survive. However, you start to develop an infection.\n');
                        player.daysInfected = player.daysInfected + 1;
                        poundsofBuffaloMeat = randi([125 250]);
                        shop.bullets = shop.bullets - bulletsNeededforBuffalo;
                        shop.food = shop.food + poundsofBuffaloMeat;
                        bulletsNeededforBuffalo = randi([1 24]);
                        goOn;
                        break;
                    elseif (bulletsNeededforBuffalo >= shop.bullets) && (killedbyBuffalo == 0)
                        fprintf('\nYou see the buffalo, but notice you don''t have enough bullets to successfully bring any buffalo down. Luckily, the herd doesn''t notice you, so they don''t charge. You and your band continue on your journey.');
                        goOn;
                        break;
                    elseif (bulletsNeededforBufalo >= shop.bullets ) && (killedbyBuffalo == 1)
                        fprintf('\nYou see the buffalo, and start shooting some. However, the herd picks up your scent and charges you and your party. You end up being trampled.\n');
                        player.isDead = true;
                        break;
                    end
                elseif strcmp(buffaloChoice,'No') || strcmp(buffaloChoice,'no')
                    fprintf('\nGood choice. Those buffalo can be dangerous, so it makes sense that you don''t to risk it.');
                    goOn;
                    break;
                else
                    fprintf('\nI know it is a hard decision, but a yes or no will do.\n\n');
                end
            end
        elseif (eventDecision == 5)
            fprintf('You drink contaminated water and develop dysentary.\n');
            player.daysInfected = player.daysInfected + 1;
            goOn;
        elseif (eventDecision == 6) && (strcmp(player.Name,'Kramer') || strcmp(player.Name,'Miles') || strcmp(player.Name,'Herbie Husker'))
            fprintf('Aliens sought you out to help you to your destination. They test their teleporter, and they transport you to your final destination - Portland, Oregon.\n\n');
            player.isWon = true;
            player.finalDestination = "Portland, Oregon";  
        elseif (eventDecision == 6) 
            player.Stay = input('You notice you really enjoy the area that you are in currently. Do you want to stay instead of finishing your journey? (Yes or No)\n','s');
              while true
                if strcmp(player.Stay, 'Yes') || strcmp(player.Stay, 'yes')
                    player.isWon = true;
                    break;
                elseif strcmp(player.Stay, 'No') || strcmp(player.Stay, 'no')
                    fprintf('\nThat makes sense. You set out to reach Portland, and you want to finish your journey. Keep going %s!\n',player.Name);
                    goOn;
                    break;
                else
                    fprintf('\nI know this is a hard decision, but a yes or a no will do.');
                end
              end
        end
    checkEndGame;
    end
end

%Function that displays the store to buy goods
function [] = generalStore()
    global shop;
    
    shop.bullets = 25;
    shop.money = randi([45 242]);
    shop.food = 100;
    shop.thunderclappers = 0;
    
    shop.figure = figure('numbertitle','off','name','The General Store'); % Find a way to make just this bigger to bring attention to it
    shop.adventureStart = uicontrol('style','pushbutton','position',[136 50 280 40],'string','Start Adventure','callback',{@adventure});
    shop.title = uicontrol('style','text','position',[200 400 140 20],'string','THE GENERAL STORE','horizontalalignment','center');
    
    %Displays the different changeable variables
    shop.moneyDisplay = uicontrol('style','text','position',[20 330 80 60],'string',['Available Money: $',num2str(shop.money)]);
    shop.foodDisplay = uicontrol('style','text','position',[20 260 80 60],'string',['Current foodstuffs (in pounds): ', num2str(shop.food)]);
    shop.bulletsDisplay = uicontrol('style','text','position',[20 185 80 60],'string',['Bullets owned: ', num2str(shop.bullets)]);
    shop.thunderclappersDisplay = uicontrol('style','text','position',[20 110 80 60],'string',['Thunderclappers owned: ' num2str(shop.thunderclappers)]);
    
    shop.products(1) = uicontrol('style','pushbutton','position',[280 290 140 20],'string','Foodstuffs (50 pounds)','callback',{@sellProduct,45,1});
    shop.price(1) = uicontrol('style','text','position',[190 286 80 20],'string','Price: $45.00','horizontalalignment','right');
    shop.stock(1) = uicontrol('style','text','position',[390 271 140 20],'string','Current Stock: 5','horizontalalignment','right');
    
    shop.products(2) = uicontrol('style','pushbutton','position',[280 222 140 20],'string','Bullets (50 count)','callback',{@sellProduct,35,2});
    shop.price(2) = uicontrol('style','text','position',[190 218 80 20],'string','Price: $35.00','horizontalalignment','right');
    shop.stock(2) = uicontrol('style','text','position',[390 203 140 20],'string','Current Stock: 5','horizontalalignment','right');
    
    shop.products(3) = uicontrol('style','pushbutton','position',[280 147 140 20],'string','Thunderclappers (5 count)','callback',{@sellProduct,15,3});
    shop.price(3) = uicontrol('style','text','position',[190 143 80 20],'string','Price: $15.00','horizontalalignment','right');
    shop.stock(3) = uicontrol('style','text','position',[390 128 140 20],'string','Current Stock: 5','horizontalalignment','right');
   
    %Function to control the withdrawl of $
    function [] = addMoney(source,event,cash)
        shop.money = shop.money + cash;
        shop.moneyDisplay.String = ['Available Money: ' num2str(shop.money)];
    end
    %Function to sell the product
    function [] = sellProduct(source,event,price,index)
        if (shop.money >= price) && (str2double(shop.stock(index).String(end)) > 0)
           addMoney(0,0,-1*(price));
           currentStock = shop.stock(index).String(end);            
           currentStock = str2double(currentStock);            
           currentStock = currentStock - 1;            
           currentStock = num2str(currentStock);            
           shop.stock(index).String = ['Current Stock: ', currentStock];
           message = ['You received ' source.String];
           msgbox(message,'General Store','modal');
           if strcmp(source.String, 'Foodstuffs (50 pounds)')
               shop.food = shop.food + 50;
               shop.foodDisplay.String = ['Current foodstuffs (in pounds): ' num2str(shop.food)];
           elseif strcmp(source.String, 'Bullets (50 count)')
               shop.bullets = shop.bullets + 50;
               shop.bulletsDisplay.String = ['Bullets owned: ' num2str(shop.bullets)];
           elseif strcmp(source.String,'Thunderclappers (5 count)')
               shop.thunderclappers = shop.thunderclappers + 5;
               shop.thunderclappersDisplay.String = ['Thunderclappers owned: ' num2str(shop.thunderclappers)];
           end
        else
            message = ('Sorry, you do not have enough money to make that purchase.');
            msgbox(message,'General Store Error','error','modal');
            
        end
    end
end

%Function that displays your stats at the end of the game (whether you won
    % or not)
function [] = endofGameStats()
    global shop;
    global player;
    fprintf('\nGAME STATS\n');
        fprintf('\nYour final destination was %s.\n',player.finalDestination);
        if player.daysTraveled == 1
            fprintf('You traveled %d day.\n',(player.daysTraveled));
        elseif player.daysTraveled > 1
            fprintf('You traveled %d days.\n',player.daysTraveled);
        end
        if shop.food == 1
            fprintf('You had 1 pound of food remaining.\n');
        elseif shop.food ~= 1
            fprintf('You had %d pounds of food remaining.\n',shop.food);
        end
        if shop.bullets == 1
            fprintf('You had %d bullet left.\n',(shop.bullets));
        elseif shop.bullets ~= 1
            fprintf('You had %d bullets left.\n',shop.bullets);
        end
        if shop.thunderclappers == 1
            fprintf('You had %d thunderclapper left.\n',(shop.thunderclappers));
        elseif shop.thunderclappers ~= 1
            fprintf('You had %d thunderclappers left.\n',shop.thunderclappers);
        end
       fprintf('Thank you for playing!\n');
end

%Function that asks if the user wants to continue or not
function [] = goOn()
    while true
       global player;
       playerGoOn = input('\nWould you like to continue? (Yes or No)\n','s');
                if strcmp(playerGoOn, 'Yes') || strcmp(playerGoOn,'yes')
                    fprintf('\nExcellent. We now journey to the next day.\n');
                    eventDecision = randi([1 6]);
                    break;
                elseif strcmp(playerGoOn, 'No') || strcmp(playerGoOn,'no')
                    fprintf('\nI understand %s. Thank you for playing!\n',player.Name);
                    player.isDone = true;
                    break;
                else
                    fprintf('\nI know it is a hard decision, but a yes or no will do.\n');
                end
    end
end

%Function to check if the game is done
function [] = checkEndGame()
   global player;
   if player.daysInfected >= 10
       fprintf('\nYour body fought hard against the infection, but in the end the infection won out. You died of a bacterial infection.\nGAME OVER.');
       player.isDead = true;
   end
   
   if player.isDead == true
       fprintf('Unfortunately, you didn''t survive your journey.\n');
       endofGameStats;
   end
   
   if player.isWon == true
       fprintf('\nC O N G R A T U L A T I O N S ! You have successfully completed your journey!\n');
       endofGameStats;
   end
   
   if player.isDone == true
       fprintf('\nYou have decided to exit the game.\n');
       endofGameStats;
   end
end