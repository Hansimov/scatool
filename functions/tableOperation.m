function tableOperation(table_src,table_event,table_traceinfo)

    global container;
    % When a cell is selected, it will cause an error when do other things.
    if isempty(table_event.Indices)
        return;
    end
    
    row = table_event.Indices(1);
    col = table_event.Indices(2);
    ctmenu = uicontextmenu;
    table_src.UIContextMenu = ctmenu;

    cell_data = get(table_src, 'Data');
    name_part = cell_data{row,2};
    ext_part = cell_data{row,3};
    path_part = cell_data{row,4};
    full_name = [path_part name_part ext_part];
%     set(table_traceinfo,'Data',file_info{row,1});
    set(table_traceinfo,'Data',container.files{row,1}.info);
    table_traceinfo.ColumnFormat = {'char' 'char'};
    
    creatContext();

    function creatContext()
        if col == 2
            if strcmp(ext_part,'.trs')
                uimenu(ctmenu,'Label','ת���� .mat ��ʽ','Callback',@convertToMat);
            end
            if strcmp(ext_part,'.mat')
                uimenu(ctmenu,'Label','�鿴����','Callback',@viewFile);
            end
            uimenu(ctmenu,'Label','ɾ������','Callback',@deleteFile);
        elseif col == 4
            uimenu(ctmenu,'Label','����·���������ļ�����','Callback',@copyFullname);
            uimenu(ctmenu,'Label','����·��','Callback',@copyDir);
        end
    end
    function copyFullname(~,~)
        disp(full_name);
    end
    function copyDir(~,~)
        disp(path_part);
    end

    function viewFile(~,~)
        plotResult(cell2mat(container.files{row,1}.entity.trs_sample(1,1)), 1e-8, 0.005);
    end
    function deleteFile(~,~)
        container.files(row,:) = [];
        container.file_pointers(row,:) = [];
        set(table_traceinfo,'Data',{});
        set(table_src, 'Data', container.file_pointers);
    end
    
    function convertToMat(~,~)
        trs_fullname = full_name;
        [mat_filename,mat_pathname] = uiputfile('*.mat', '����Ϊ...',[path_part filesep name_part]);
        if mat_filename ~=0
            mat_fullname = [mat_pathname,mat_filename];
        else
            return;
        end
         [~,canceled] = trs2mat(trs_fullname,mat_fullname);
         if ~canceled
             file_open_choice = questdlg('�ļ�����ɹ����Ƿ��������д򿪣�', '', ...
                                        '��','��','��');
             switch file_open_choice
                 case '��'
                     [mat_path_part,mat_name_part,mat_ext_part] = fileparts(mat_fullname);
                     container.file_pointers(end+1,1:4) = {false,mat_name_part,mat_ext_part,mat_pathname};
                     container.files{end+1,1} = TraceFile(mat_fullname);
%                      file_info{end+1,1} = get_trs_info(full_name);
                     set(table_src,'Data',container.file_pointers);
                 case '��'
                 otherwise
             end
         end
    end



end
