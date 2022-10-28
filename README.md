 # Odin Localization

### Main components
* https://react.i18next.com/ - the front-end translation system we are using
* https://github.com/parkbenchsolutions/locales - the location of our translation resource files
* https://github.com/parkbenchsolutions/odinweb/pull/3358 - feature/i18n branch we are using to update odinweb

### The big picture
Our customers require us to provide the ability for Odin (odinweb) to display the UI in a variety of languages. 
We have selected a JavaScript library (i18next) that will provide runtime translation of any label
that is wrapped in a special function. This function handles looking up the KEY in a resource file for a certain
language and returning the TRANSLATION for that key.

In this manner, Odin's UI can display any new language by providing new resource files for the target language.

We have chosen to use the ENGLISH label as the KEY. If the KEY is looked up in a resource file and not found,
the KEY will itself be returned by the library and therefore ENGLISH will be displayed.

### The work

REQUIREMENT: Every label used in Odin needs to be added to the ENGLISH resource file in the "locales" repository.
```text
https://github.com/parkbenchsolutions/locales/tree/master/en-US
```

Take note, however, that OdinWeb is NOT responsible for translating any direct results of API/OCI calls. BroadWorks error messages or Feature names or lists returned directly from BroadWorks are displayed AS IS.

Notice there are several files. Each is a "namespace" where certain kinds of tags are grouped together.

| File name | Description                                                   |
|:---:|:--------------------------------------------------------------|
| bulkProvisioning.json | Anything related to bulk provisioning                         |
| common.json | The default namespace. All common or universal labels go here |
| errors.json | Any user messages, Alert messages, errors, etc.               |
| formFields.json | All form fields                                               |
| group.json | All files at the group level store tags here                  |
| menuItems.json | All menu items                                                |
| serviceProvider.json | All files at the service provider level store tags here       |
| system.json | All files at the system level store tags here                 |
| user.json | All files at the user level store tags here                   |

Other files/namespaces can be created, but there should be a good reason. It is better to "lump" together than "split" them up for simplicity of file loading and customer translation work.

REQUIREMENT: Each file in OdinWeb that has labels needs to have those labels translated in one of the following ways:
1) Many of our components now provide translation of labels "out of the box". For example, you don't have to do anything in UiModal or UiFormField to have the label attributes translated. Components with translations enabled:
   * UiCard
   * UiCardModal
   * UiInputCheckbox
   * UiFormField
   * UiInput (a translation-enabled wrapper of Input)
   * UISelectOption (a translation-enabled wrapper of Select.Option)
   * UiDashboardDataTable
   * UiDataTableWithMoreOptions
   * UiFormFieldTextarea
   * UiListItem
   * UiSelectableTable
   * UiInput
   * All menu items (via MenuServices component)
   * All Alerts (via Alert component/functions)
   
And possibly others...

For all of these components, you can pass in a "notranslate" attribute to indicate you are handling the translation for all labels in that component yourself (by wrapping them with a ```t()``). You can also pass a "namespace" attribute to indicate which namespace you want to use. 

2) You can use a utility called ```i18nJsonArrayOfObjects``` to translate a label attribute of an array of objects.


3) While the above strategies cover a wide range of our existing labels, there are many that will not pass through one of these components and be translated. For these, you must manually wrap the label in the special translation function ```t()```

### Translating a page
As an example of what needs to be done for each page, take a look at the DIFF of branding-resources.js

```
https://github.com/parkbenchsolutions/odinweb/pull/3358/files#diff-f970ba63ab659b21dd78cad44267d96df0ae98289624fbcdfdfad63919b40c19
```

The steps to translate a page like this are as follows:
1) First add the "boilerplate" that is necessary to import the library
```text
import { useTranslation } from 'react-i18next'
```
2) Next add the following "boilerplate" to the component definition (in this case after ```export const BrandingResources...``):
```text
  const namespace = 'system'
  const { i18nJsonArrayOfObjects } = useOdinI18nService()
  const { t } = useTranslation(namespace)
  i18nJsonArrayOfObjects(columns, ['label'], namespace)
```

Note here that you specify which namespace (meaning which resource file) all of the translated KEYS on this page are to be loaded from. In this case, all KEYS will be retrieved from the "system.json" file because the branding is part of the System-level pages. Actually, branding appears at multiple levels, but we chose to put all of the KEYS into "system.json" for simplicity.

Also note that we are using the i18nJsonArrayOfObjects utility so that we can translate the "columns" array of objects. The "label" attribute of the "columns" need to be translated and the last line above accomplishes that for us. **If you aren't translating an array of objects, you can leave those imports out**

3) We should now COPY and PASTE each KEY that we find into the "system.json" file in a separate editor. Note that the format for all KEYS for our english version have the following pattern:
```text
"Resources Updated" : "Resources Updated-ODIN"
```
Note that there is the KEY on the left and the TRANSLATION for ENGLISH on the right. Our "Odin English" is including a "-ODIN" on the end of the english so that we can easily see in the UI that the token is translated.

So we would copy all of the KEYS into "system.json" from the label attributes in the "columns" object if they don't already exist in "system.json". If the KEY does already exist, then skip to the next. 

4) Next we scroll down the branding-resources.js and notice the "alertSuccess" on line 140 with an english label. We observe that the KEY that will be generated at runtime will be either "Resources Updated" or "Resources Saved", depending on the status of the action variable. Because "alertSuccess" will translate whatever key is sent, we add both of those two KEYS to the "system.json" file. No other action is required, because the alertSuccess function will handle running the ```t()``` on the label and returning the translation.


5) Next, on line 162 we observe a special title that required interpolation. Interpolation allows us to pass a variable to the translation function that the translator can use wherever they like in their language version of the string. NOTE: if you manually make a translation that uses interpolation in a label of a component, you will need to add the "notranslate" attribute. This signals to the component that you are handling all the translation yourself. Therefore, if there were other label attributes, you would have to wrap them in the ```t()``` as well.

You can see other examples of manually translating labels in the file. When you create interpolated KEYS you'll need to add the variable to your KEY in the resource file slightly differently. 

So for a label such as this:
```text
title={t('Resources for hostname', {hostname:hostname})}
```

In the resource file, you would add a KEY such as this:
```text
"Resources for hostname": "Resources for: {{hostname}}"
```

The translation function will interpolate the hostname variable passed in and place it in place of the {{hostname}} locator.

6) Notice on line 199 the ```<Input``` tag has been changed to ```<UiInput```. That's because there is a "placeholder" attribute with a label that must be translated. For all other Input tags that do not have a label that must be translated, you can leave them as they are. **NOTE that all KEYS that are on UiInput tags are by default in the "formFields.json" namespace file (NOT in the system.json file).** So be sure to add the KEYS to the proper file.

7) Finally, on line 246, there is a ```<p>``` element that must be translated. Even though it is inside of the UiCardModal, the child JSX will not be translated so you must wrap it yourself with the ```t()```.

```text
<p>{t('Are you sure you want to remove this Resource?')}</p>
```

And then add that KEY to the resource file.

Once you have completed the translation markup of a file and added all KEYS to the proper resource file(s), you can merge your changes into the repository and then go view the page in the UI. VERIFY: are all of the labels translated? If not, continue the above process until all labels are translated.

# Other possibly helpful notes:

### To make a new namespace
1. add to i18n.js
2. create the namespace file in the english language directory ("en-US") of locales repo (has to be valid JSON format)
3. push to git


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

Note that you have to provide the milliseconds param (3000) and then "true" parameter to indicate you want to override the auto-translation

### Translating multiple labels in an array of objects
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
or another option, do the ternary and send the label to be translated as usual:
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
In the case of a variable being concatenated with a string literal, you can just wrap it as-is:
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

We made a slight change to the UiFormField so that ASTERISKS are not part of the translated label.
In the case of a required field, add the "required" attribute and REMOVE the asterisk.

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

