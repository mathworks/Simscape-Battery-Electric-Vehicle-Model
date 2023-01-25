function checkCallbackButton(targetModel, fileList)
%% Checks ClickFcn callback of Callback Button block
% This function finds Callback Button blocks from the target model (1st argument)
% and checks the content of its ClickFcn callback.
% If ClickFcn contains the `edit` command, check is made such that
% filename passed to it exists in the file list (2nd argument).
% If ClickFcn does not contain `edit`, ClickFcn is evaluated.
%
% There is a strong assumption that ClickFcn is extremely simple and short,
% especially when `edit` is used.
%
% Not evaluating `edit` is important because `edit` always errors
% if MATLAB is launched with -nodesktop option,
% which is the case in Continuous Integration (CI) pipeline,
% meaning that CI fails once `edit` is evaluated.
% However, it is still important to programatically check that
% `edit` works in interactive mode.
% Thus, we check the existance of file passed to `edit`.
%
% Callback Button blocks within referenced subsystems included in
% the target model are not checked.
% To check those blocks, pass the referenced subsystem to this function.

% Copyright 2023 The MathWorks, Inc.

arguments
  targetModel (1,:) {mustBeText} = ""
  fileList (:,1) {mustBeText} = ""
end

% Find Callback Button blocks.
pathToCallbackButtons = string(getfullname(Simulink.findBlocksOfType(targetModel, "CallbackButton")));
numButtons = numel(pathToCallbackButtons);

if numButtons == 0
  return  % <======================================================= RETURN
end

disp("Found " + numButtons + " Callback Button block(s):")
disp(pathToCallbackButtons)
disp(" ")

% Find referenced subsystems.
find_opts = Simulink.FindOptions(RegExp = true);
refsubs = Simulink.findBlocksOfType(bdroot, "SubSystem", "ReferencedSubsystem", ".", find_opts);
refsubs = string(getfullname(refsubs));

disp("Found referenced subsystem(s):")
disp(refsubs)
disp(" ")

% For each discovered block, check code in ClickFcn callback.
for idx = 1 : numButtons
  disp(newline + ">>> " + idx + ": " + pathToCallbackButtons(idx))

  % Path to target block
  blkPath = pathToCallbackButtons(idx);

  if startsWith(blkPath, refsubs)
    disp("Skipping because the block is under referenced subsystem.")
    continue  % <================================================= CONTINUE
  end

  % Get the code to test.
  codeStr = get_param(blkPath, "ClickFcn");

  % If `edit` is used in the code string, the string is not evaluated.
  % Instead, the file being passed to `edit` is checked its existence.
  % This is based on the assumption that
  % if edit is found, the code string only contains one line for edit.

  pat = letterBoundary + "edit" + letterBoundary;

  if contains(codeStr, pat)
    disp("Found `edit` in ClickFcn. Check that the file passed to `edit` exists in the file list.")

    % Attempt to get the filename passed to edit.
    % Pattern matching logic here is kept intentionally simple.
    % The check succeeds only if the line containing edit is
    % straightforward, like edit("foo.m").

    % Get ("foo.m") from edit("foo.m")
    filename = extractAfter(codeStr, pat);

    % Get foo.m from ("foo.m") or ('foo.m')
    filename = extractBetween(filename, "("+(""""|"'"), (""""|"'")+")");

    disp("Filename passed to edit: " + filename)

    found = true;
    if endsWith(filename, [".m", ".mlx"])
      lix = endsWith(fileList, filename);  % logical index
      if all(lix == 0)
        found = false;
        warning("File not found: " + filename)
      end
    else
      lix = endsWith(fileList, [filename+".m", filename+".mlx"]);
      if all(lix == 0)
        found = false;
        warning("File not found: " + filename+".m, " + filename+".mlx")
      end
    end

    if found
      assert(nnz(lix) == 1, ...
        "Only one file should be found, but two or more files were found: " ...
        + join(fileList(lix), ", "))
      fullPathToFile = fileList(lix);
      disp("Found: " + fullPathToFile)
    end

  else
    % If `edit` is not found in the ClickFcn code string, evaluate it.
    disp("  >>> Evaluating ClickFcn. This must finish without warning or error.")
    eval(codeStr)
    disp("  <<< done.")

  end  % if
end  % for

end  % function
