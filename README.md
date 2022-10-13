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

### For interpolated messages:
You can provide parameters to messages like so:
```title={t('Task',{ns: 'bulkProvisioning', task: task})}```
where ``task`` is the variable you want to supply. 

Then you need to add the following key to the resource file:
```"Task": "Task: {{task}}",```
Note the double braces for where to interpolate the parameter.

The translation then becomes: **Task: user.create** or whatever the task might be.

### Alerts
You can pass in a specific translation for alerts, such as interpolations:
```alertSuccess(t('Import Queued', {ns: 'bulkProvisioning', id: data.id}),3000,true)```
Note that you have to provide the milliseconds param (3000) and then "true" to indicate you want to override
the auto-translation

### array of objects
Use this utility to translate attributes in an array of json objects:
```i18nJsonArrayOfObjects(serviceData, ['name','description'], 'bulkProvisioning')```