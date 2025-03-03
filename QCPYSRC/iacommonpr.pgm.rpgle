**free
      //%METADATA                                                      *
      // %TEXT ISERVICE - Prototype Declaration                        *
      //%EMETADATA                                                     *

/if defined(IACOMMONSV_executeCommand)
   dcl-pr IACOMMONSV_executeCommand ind extProc(*dclCase);
      command_string varchar(2000) const options(*trim);
   end-pr;
/endif

/if defined(IACOMMONSV_executeSqlStatement)
   dcl-pr IACOMMONSV_executeSqlStatement ind extProc(*dclCase);
      input_string varchar(2000) const options(*trim);
   end-pr;
/endif

/if defined(IACOMMONSV_getFileDescOutput)
   dcl-pr IACOMMONSV_getFileDescOutput ind extProc(*dclCase);
      from_library varchar(10) const options(*trim);
      from_file varchar(10) const options(*trim);
      request_type varchar(10) const options(*trim);
      output_library varchar(10) const options(*trim);
      output_file varchar(10) const options(*trim);
   end-pr;
/endif

/if defined(IACOMMONSV_clearPhysicalFile)
   dcl-pr IACOMMONSV_clearPhysicalFile ind extProc(*dclCase);
      library_name varchar(10) const options(*trim);
      file_name varchar(10) const options(*trim);
   end-pr;
/endif

/if defined(IACOMMONSV_isObjectExists)
   dcl-pr IACOMMONSV_isObjectExists ind extProc(*dclCase);
      object_library varchar(10) const options(*trim);
      object_name varchar(10) const options(*trim);
      object_type varchar(10) const options(*trim);
   end-pr;
/endif

/if defined(IACOMMONSV_getProgramReferenceOutput)
   dcl-pr IACOMMONSV_getProgramReferenceOutput ind extProc(*dclCase);
      from_library varchar(10) const options(*trim);
      from_file varchar(10) const options(*trim);
      object_type varchar(10) const options(*trim);
      output_library varchar(10) const options(*trim);
      output_file varchar(10) const options(*trim);
   end-pr;
/endif

/if defined(IACOMMONSV_getFileRelationOutput)
   dcl-pr IACOMMONSV_getFileRelationOutput ind extProc(*dclCase);
      from_library varchar(10) const options(*trim);
      from_file varchar(10) const options(*trim);
      output_library varchar(10) const options(*trim);
      output_file varchar(10) const options(*trim);
   end-pr;
/endif

/if defined(IACOMMONSV_getObjectDescOutput)
   dcl-pr IACOMMONSV_getObjectDescOutput ind extProc(*dclCase);
      from_library varchar(10) const options(*trim);
      from_file varchar(10) const options(*trim);
      object_type varchar(10) const options(*trim);
      output_library varchar(10) const options(*trim);
      output_file varchar(10) const options(*trim);
   end-pr;
/endif

/if defined(IACOMMONSV_getFileFeildDescOutput)
   dcl-pr IACOMMONSV_getFileFeildDescOutput ind extProc(*dclCase);
      from_library varchar(10) const options(*trim);
      from_file varchar(10) const options(*trim);
      output_library varchar(10) const options(*trim);
      output_file varchar(10) const options(*trim);
   end-pr;
/endif

