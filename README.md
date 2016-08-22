# Trello2Postit
iOS App for printing post-its from Trello lists

#Configure
Add a 'configfile' to the project and paste this json with the lists url:

```{
    "trello": {
        "panels": [
            {
                "url": "https://api.trello.com/1/lists/LIST_ID/cards?key=KEY&token=TOKEN",
				        "name": "Mobile"
            },
            {
                "url": "https://api.trello.com/1/lists/LIST_ID/cards?key=KEY&token=TOKEN",
			        	"name": "Backend"
            }
        ]
    }
}```
