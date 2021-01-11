classdef bsds_dataset
    properties
        bsds_path
    end
    properties(Dependent)
        data_path
        images_path
        gt_path
        train_sample_names
        val_sample_names
        test_sample_names
    end
    
    methods
        function obj = set.bsds_path(obj, bsds_path)
            obj.bsds_path = bsds_path;
        end
        
        function data_path = get.data_path(obj)
            data_path = fullfile(obj.bsds_path, 'BSDS500', 'data');
        end
        
        function obj = set.data_path(obj, ~)
            fprintf('%s%d\n','data_path is: ',obj.data_path)  
            error('You cannot set data_path explicitly');  
        end
        
        function images_path = get.images_path(obj)            
            images_path = fullfile(obj.bsds_path, 'images');
        end
        
        function obj = set.images_path(obj, ~)            
            fprintf('%s%d\n','images_path is: ',obj.images_path)  
            error('You cannot set images_path explicitly');  
        end
        
        function gt_path = get.gt_path(obj)
            gt_path = fullfile(obj.bsds_path, 'groundTruth');
        end
        
        function obj = set.gt_path(obj, ~)
            endfprintf('%s%d\n','gt_path is: ',obj.gt_path)  
            error('You cannot set gt_path explicitly');  
        end
        
        function train_sample_names = get.train_sample_names(obj)
            train_sample_names = sample_names(obj.images_path, 'train');
        end
        
        function obj = set.train_sample_names(obj, ~)
            endfprintf('%s%d\n','train_sample_names is: ',obj.train_sample_names)  
            error('You cannot set train_sample_names explicitly');  
        end
        
        function val_sample_names = get.val_sample_names(obj)
            val_sample_names = sample_names(obj.images_path, 'val');
        end
        
        function obj = set.val_sample_names(obj, ~)
            endfprintf('%s%d\n','val_sample_names is: ',obj.val_sample_names)  
            error('You cannot set train_sample_names explicitly');  
        end
        
        function test_sample_names = get.test_sample_names(obj)
            test_sample_names = sample_names(obj.images_path, 'test');
        end
        
        function obj = set.test_sample_names(obj, ~)
            endfprintf('%s%d\n','test_sample_names is: ',obj.test_sample_names)  
            error('You cannot set test_sample_names explicitly');  
        end
        
        function image=read_image(obj, name)
            path = fullfile(obj.images_path, strcat(name, '.jpg'));
            image = imread(path);
            image = double(image);
            image = image/255.;
        end
        
        function shape = get_image_shape(obj, name)
            path = fullfile(obj.images_path, strcat(name, '.jpg'));
            image = imread(path);
            shape = size(image);
        end
        
        function result = ground_truth_mat(obj, name)
            path = fullfile(obj.gt_path, strcat(name, '.mat'));
            result = load_ground_truth_mat(path);
        end
        
        function result = segmentations(obj, name)
            path = fullfile(obj.gt_path, strcat(name, '.mat'));
            result = load_segmentations(path);
        end
        
        function result = boundaries(obj, name)
            path = fullfile(obj.gt_path, strcat(name, '.mat'));
            result = load_boundaries(path);
        end
        
    end
    
    methods(Static)
        function names=sample_names(dir, subset)
            names = {};
            files = dir(fullfile(dir, subset));
            for i=1:1:length(files)
                [dir, name, ext] = fileparts(files(i));
                ext_lower = lower(ext);
                if strcmp(ext_lower, '.jpg')
                    names = [names fullfile(subset, name)];
                end
            end
        end
        
        function groundTruth=load_ground_truth_mat(path)
            load(path, 'groundTruth');
        end
        
        function results=load_segmentations(path)
            gt = load_ground_truth_mat.load_ground_truth_mat(path);
            num_gts = size(gt, 2);
            results = {};
            for i = 1:1:num_gts
                gt_item = gt(1, i);
                seg = gt_item{1,1}.Segmentation;
                results = [results, int32(seg)];   
            end
        end
        
        function results=load_boundaries(path)
            gt = bsds_dataset.load_ground_truth_mat(path);
            num_gts = size(gt, 2);
            results = {};
            for i = 1:1:num_gts
                gt_item = gt(1, i);
                seg = gt_item{1,1}.Boundaries;
                results = [results, seg];   
            end
        end
    end
                    
                
      
    
    
end        
            