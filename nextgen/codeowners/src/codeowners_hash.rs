use moon_config::{CodeownersConfig, OwnersConfig};
use moon_hash::hash_content;
use std::collections::BTreeMap;

hash_content!(
    pub struct CodeownersHash<'cfg> {
        projects: BTreeMap<&'cfg str, &'cfg OwnersConfig>,
        workspace: &'cfg CodeownersConfig,
    }
);

impl<'cfg> CodeownersHash<'cfg> {
    pub fn new(workspace: &CodeownersConfig) -> CodeownersHash {
        CodeownersHash {
            projects: BTreeMap::new(),
            workspace,
        }
    }

    pub fn add_project(&mut self, name: &'cfg str, config: &'cfg OwnersConfig) {
        self.projects.insert(name, config);
    }
}
