 ### Odin Locales

 #### Internationalization of Odin


### To make a new namespace
1. add to i18n.js
2. create the namespace file in the english language directory ("en-US") of locales repo (has to be valid JSON format)
3. push to git

### To update a file
1. add import:
   ``` import { useTranslation } from 'react-i18next'; ```
2. add translation function in body of component:
   ``` const { t } = useTranslation();```
3. replace all strings
   1. copy and paste the string into the english locales file: ```"Name": "Name"``` 
   2. use the t function in a react label: 
      ```{t('Name', { ns: 'bulkProvisioning' })} ```
   3. or use the t function to replace a string (no curly braces): 
      ```t('Name', { ns: 'bulkProvisioning' })```

When you're finished, copy the english file to other language directories and translate.

*TODO*: probably want to find a translation tool to help manage that process and generate files.

