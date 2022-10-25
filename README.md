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
```
title={t('Task',{ns: 'bulkProvisioning', task: task})}
```
where ``task`` is the variable you want to supply. 

Then you need to add the following key to the resource file:
```
"Task": "Task: {{task}}",
```
Note the double braces for where to interpolate the parameter.

The translation then becomes: **Task: user.create** or whatever the task might be.

### Alerts
You can pass in a specific translation for alerts, such as interpolations:
```
alertSuccess(t('Import Queued', {ns: 'bulkProvisioning', id: data.id}),3000,true)
```

Note that you have to provide the milliseconds param (3000) and then "true" to indicate you want to override
the auto-translation

### array of objects
Use this utility to translate attributes in an array of json objects:

```
const { i18nJsonArrayOfObjects } = useOdinI18nService()
i18nJsonArrayOfObjects(serviceData, ['name','description'], 'bulkProvisioning')
```

### boilerplate
```
const namespace = 'system'
const { t } = useTranslation(namespace)
const { i18nJsonArrayOfObjects } = useOdinI18nService()
i18nJsonArrayOfObjects(columns, ['label'], namespace)
```

### translate an alert
#### with interpolation:
Here we are saying we want to do the translation ourselves so we send "true" to be our "notranslate" flag
```
alertSuccess(
   t(`Template ${action === 'edit' ? 'Updated' : 'Saved'}`),
   3000,
   true
)
```
#### without interpolation
or another option, do the ternary and send the label to be translated:
```text
alertSuccess((action==='edit') ? 'Resources Updated' : 'Resources Saved')
```
However, you'll add TWO tags to the resource file: "Resources Updated" and "Resources Saved" 
another example of this is:
```text
alertSuccess(`Sso Admin Id ${action === 'edit' ? 'Updated' : 'Saved'}`)
```

You needn't do anything with this, but you need to add what the tags will be to the resource file:
"Sso Admin Id Updated" and "Sso Admin Id Saved"

### Use existing string concatenation
```text
title={t(`${endpointEditMode} Localization Settings`)}
```
In this case you would add these tags to the resource file:
"Add Localization Settings"
"Edit Localization Settings"
since Add and Edit are the two possibilities for "endpointEditMode" param

### For input fields
```text
<UiFormField label="User Id *" horizontal>
```
becomes
```text
<UiFormField label="User Id" horizontal required>
```

note that ```<Input>``` tags are NOT translated.
the translated version is ```<UiInput>```
and is only necessary if there is a "placeholder=" attribute to translate

### things you don't want to translate
If a control is displaying data then you don't want to translate it:
```text
<UiInputCheckbox
              name={form.name}
              label={form.label}
              checked={form.value}
              onChange={handleInput}
              notranslate
            />
```
note the label is a variable and so we add "notranslate"

### uncovered children
Regular children elements of components need to be translated because the components do not translate them:
```text
<p>{`Are you sure you want to remove this Primary Sso Admin?`}</p>
```
needs to become:
```text
<p>{t('Are you sure you want to remove this Primary Sso Admin?')}</p>
```

