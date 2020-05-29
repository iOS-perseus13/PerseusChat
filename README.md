# PerseusChat

# 1.	The APP (Perseus Chat App):
      The intention is to make a Chat App to be used to communicate in between the employees through internet. 

# 2.	MVP:
      Initially the MVP target is to build an App for: 
        1.	end to end communication
        2.	multiuser communication through a chat room

# 3.	High level Design:
      The user journey will be 
#       1.	Initial screen
                a.	If user is logged in: Home screen
                b.	If user in not logged in: Sign-in/ Sign-up screen
#        2.	Sign-up screen:
            This will be simple user registration screen. To avoid other users to register, we currently will restrict   
            @perseusinternational.net account only. The user will get a link in their email to activate the registration.   
             Screen components:
                a.	Full name (textField)
                b.	Email address (textField)
                c.	Password (secured textField)
                d.	Confirm password (secured textField)
                e.	Register (button)
                f.	Cancel (button)
#       3.	Sign-in screen:
            This will be simple user login screen. To avoid other users to login, we currently will restrict 
            @perseusinternational.net account only. Screen components:
                a.	Email address (textField)
                b.	Password (secured textField)
                c.	Login (button)
                d.	Cancel (button)
             After successful log-in (we will persist the login state unless the user signs out). The user will be presented 
             to Home screen.

#       4.	Home screen:
            This will be a multi-tabbed screen. Initially only
                a.	Chat tab and 
                b.	More tab 
                Will be functional. The other tabs will be placeholder. 

#       5.	Chat Tab:
            This will list of two types:
                a.	First list will show the channels where the user is participating. 
                    The user can click any of the item from the list to:
                        i)	View the messages history of that channel
                        ii)	Send messages to the channel
                        iii)	Going back will take the user to the Initial Chat Tab screen
                b.	The second list will show all the users registered in the company.
                    The user can click any of the user from the list to:
                        i)	View the messages history with the user
                        ii)	Send messages to the user
                    Going back will take the user to the Initial Chat Tab screen
                c.	There will be a search bar to search for 
                        i)	channel (group) or
                        ii)	user
                d.	There will be a shortcut buttons on left-top of the screen, that will show a sheet, where the user can:
                        i)	Create new channel (group)
                        ii)	Search for channel or user
                e.	There will be a shortcut buttons on right-top of the screen, that will allow the user to select 
                    channel(s) and or user(s):
                        i)	To delete from the list 
#       6.	More tab:
            The more tab will be also a list of multi sectioned list:
                a.	In the first section (User Profile):
                        i)	Change their name
                        ii)	Status (Available, busy, on call etc.)
                        iii)	Log out/ Sign-in (Sign-in screen will have both sign-in and sign-up option) 
                b.	In the second section (About the App):
                        i)	App version
                        ii)	Notifications settings
                        iii)	Feedback etc

# 4.	Coming features:  
        1.	Send files
        2.	Audio Calling
        3.	Video Calling 

